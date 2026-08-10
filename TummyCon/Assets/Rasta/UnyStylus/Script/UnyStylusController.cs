
using System;
using Rasta.UnyStylus.CustomTouchableCanvas;
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDK3.Components;
using VRC.SDKBase;
using VRC.Udon;
using VRC.Udon.Common;

namespace Rasta.UnyStylus
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
    public class UnyStylusController : UdonSharpBehaviour
    {
        public Transform penTipTransform;
        [SerializeField] private Renderer penColorRenderer;
        [SerializeField] private int penColorRendererMaterialIndex = 0;

        [Space(10)]
        public UnyStylus unyStylus;
        [SerializeField] private Transform menuTransform;
        [SerializeField] private GameObject lineRendererPrefab;
        [SerializeField] private Material inkPc;
        [SerializeField] private Material inkMobile;
        [SerializeField] private Material inkPcSelected;
        [SerializeField] private Material inkMobileSelected;
        [SerializeField] private Menu_ColorWheel colorWheelMenu;
        [SerializeField] private Menu_PenMode penModeMenu;
        [SerializeField] private Menu_WidthSlider widthSliderMenu;
        [SerializeField] private CustomTouchableCanvas.TouchableCanvas touchableCanvas;
        [SerializeField] private Animator modelAnimator;
        [SerializeField] private Pen penTool;
        [SerializeField] private float desktopSensitivity = 0.03f;
        [SerializeField] private GameObject desktopCursor;
        [SerializeField] private WorldUI worldUI;

        private float secondaryThumbstickVertical = 0.0f;
        private float beforeSecondaryThumbstickVertical = 0.0f;
        private DateTime lastThumbstickDownTime = DateTime.MinValue;

        private VRCPickup pickup;

        private bool befIsTouched = false;

        private DateTime hideModelTime = DateTime.MinValue;

        [HideInInspector] public LinePool linePool;

        private bool isSetDefaultScale = false;
        private Vector3 menuDefaultScale;
        [UdonSynced, FieldChangeCallback(nameof(SyncedOwnerEyeHeight))] private float syncedOwnerEyeHeight = 0.0f;

        private bool isTabKeyPressed = false;
        private Vector2 mousePosition;

        void Start()
        {
            
            if (linePool.linePrefab == null)
            {
                linePool.linePrefab = lineRendererPrefab;
                linePool.inkPc = inkPc;
                linePool.inkMobile = inkMobile;
                linePool.inkPcSelected = inkPcSelected;
                linePool.inkMobileSelected = inkMobileSelected;
            }
            penTool.SetLineMaterial(inkPc, inkMobile);

            unyStylus.GetComponent<Collider>().enabled = Networking.LocalPlayer.IsOwner(unyStylus.gameObject);
            pickup = unyStylus.GetComponent<VRCPickup>();
            
            Material[] newMaterials = new Material[colorWheelMenu.colorMaterials.Length + 1];
            Array.Copy(colorWheelMenu.colorMaterials, newMaterials, colorWheelMenu.colorMaterials.Length);
            newMaterials[newMaterials.Length - 1] = penColorRenderer.materials[penColorRendererMaterialIndex];
            colorWheelMenu.colorMaterials = newMaterials;

            modelAnimator.SetBool("isShow", Networking.IsOwner(gameObject));

            if (Networking.IsOwner(gameObject))
            {
                if (worldUI)
                {
                    worldUI.SetEnableQuickCall(unyStylus.isEnableQuickCall);
                }
                SendCustomEventDelayedSeconds(nameof(SetPenColor), 1.0f);
            }
        }

        public void SetPenColor()
        {
            Color defaultColor = unyStylus.playerColors[(Networking.LocalPlayer.playerId - 1) % unyStylus.playerColors.Length];
            colorWheelMenu.SyncedLineColor = defaultColor;
        }
        
        void Update()
        {
            if (Networking.IsOwner(gameObject))
            {
                secondaryThumbstickVertical = Input.GetAxis("Oculus_CrossPlatform_SecondaryThumbstickVertical");

                // Summon
                if (worldUI ? worldUI.isEnableQuickCall : unyStylus.isEnableQuickCall)
                {
                    if (!pickup.IsHeld && secondaryThumbstickVertical < -0.5f && beforeSecondaryThumbstickVertical >= -0.5f)
                    {
                        if ((DateTime.Now - lastThumbstickDownTime).TotalSeconds < 0.3f)
                        {
                            Summon();
                        }
                        lastThumbstickDownTime = DateTime.Now;
                    }
                    if (Input.GetKeyDown(KeyCode.P))
                    {
                        Summon();
                    }
                }

                beforeSecondaryThumbstickVertical = secondaryThumbstickVertical;
                

                // Haptic feedback
                if (pickup.IsHeld)
                {
                    bool isTouched;
                    Vector3 screenPos;
                    Vector3 worldPos;
                    touchableCanvas.GetTouch(0, out isTouched, out screenPos, out worldPos);
                    if (isTouched && !befIsTouched)
                    {
                        Networking.LocalPlayer.PlayHapticEventInHand(pickup.currentHand, 0.1f, 0.1f, 0.05f);
                    }
                    befIsTouched = isTouched;
                }

                // Desktop
                if (!Networking.LocalPlayer.IsUserInVR() && pickup.IsHeld)
                {
                    if (Input.GetKeyDown(KeyCode.Tab))
                    {
                        isTabKeyPressed = true;
                        mousePosition = Vector2.zero;
                        desktopCursor.SetActive(true);
                    }
                    else if (Input.GetKeyUp(KeyCode.Tab))
                    {
                        isTabKeyPressed = false;
                        penTipTransform.localPosition = Vector3.zero;
                        desktopCursor.SetActive(false);
                    }

                    if (isTabKeyPressed)
                    {
                        Vector2 mouseDelta = new Vector2(Input.GetAxis("Mouse X"), -Input.GetAxis("Mouse Y"));
                        mousePosition += mouseDelta * desktopSensitivity;

                        VRCPlayerApi.TrackingData headData = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.Head);

                        penTipTransform.position = headData.position + headData.rotation * new Vector3(mousePosition.x, -mousePosition.y, 0.5f);
                    }
                }
            }

            if (!Networking.IsOwner(gameObject))
            {
                if (pickup.IsHeld)
                {
                    hideModelTime = DateTime.Now.AddSeconds(5f);
                }

                modelAnimator.SetBool("isShow", DateTime.Now < hideModelTime);
            }
        }

        private void Summon()
        {
            if (Networking.LocalPlayer.IsUserInVR())
            {
                VRCPlayerApi.TrackingData trackingData = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.RightHand);
                unyStylus.transform.position = trackingData.position + trackingData.rotation * Vector3.Lerp(Vector3.right, Vector3.forward, 1.0f) * 0.05f;
                unyStylus.transform.rotation = trackingData.rotation;
                unyStylus.transform.rotation = unyStylus.transform.rotation * Quaternion.AngleAxis(40f, Vector3.forward);
            }
            else
            {
                VRCPlayerApi.TrackingData headData = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.Head);
                unyStylus.transform.position = headData.position + headData.rotation * Vector3.forward * 0.2f;
                unyStylus.transform.rotation = Quaternion.identity;
            }

            SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.Others, nameof(SetHideModelTime));
        }

        public void SetHideModelTime()
        {
            hideModelTime = DateTime.Now.AddSeconds(5f);
        }


        public override void OnAvatarEyeHeightChanged(VRCPlayerApi player, float prevEyeHeightAsMeters)
        {
            if (player.isLocal && player.playerId == Networking.GetOwner(gameObject).playerId)
            {
                SyncedOwnerEyeHeight = Networking.LocalPlayer.GetAvatarEyeHeightAsMeters();
            }
        }

        private void SetDefaultScale()
        {
            if (isSetDefaultScale) return;

            isSetDefaultScale = true;
            menuDefaultScale = menuTransform.localScale;
        }

        private float SyncedOwnerEyeHeight
        {
            set
            {
                SetDefaultScale();

                syncedOwnerEyeHeight = value;
                menuTransform.localScale = menuDefaultScale * syncedOwnerEyeHeight / 1.2f;

                if (Networking.IsOwner(gameObject))
                {
                    RequestSerialization();
                }
            }
            get => syncedOwnerEyeHeight;
        }
    }
}
