
using UdonSharp;
using UnityEngine;
using VRC.SDK3.Components;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
    public class PenMenu : UdonSharpBehaviour
    {
        [SerializeField] private UnyStylusController controller;
        [SerializeField] private VRCPickup pickup;
        [SerializeField] private Transform menuTransform;
        [SerializeField] private Collider menuDesktopCollider;
        [SerializeField] private Animator animator;
        [SerializeField] private VRCPickup menuPickup;
        [SerializeField] private Collider menuPickupCollider;
        [SerializeField] private GameObject notOwnerCover;
        [SerializeField] private Menu_Export exportMenu;
        
        private Vector3 lastPlayerPosition = Vector3.zero;

        private float beforeSecondaryThumbstickVertical = 0.0f;
        
        [UdonSynced, FieldChangeCallback(nameof(SyncedIsMenuActive))] private bool syncedIsMenuActive = false;

        void Start()
        {
            menuTransform.parent = null;

            if (Networking.IsOwner(gameObject))
            {
                SyncedIsMenuActive = false;
                notOwnerCover.SetActive(false);
                menuDesktopCollider.enabled = !Networking.LocalPlayer.IsUserInVR();
            }
            else
            {
                notOwnerCover.SetActive(true);
                menuPickupCollider.enabled = false;
                menuDesktopCollider.enabled = false;
            }
        }

        void Update()
        {
            if (Networking.IsOwner(gameObject))
            {
                float secondaryThumbstickVertical = Input.GetAxis("Oculus_CrossPlatform_SecondaryThumbstickVertical");

                if (pickup.IsHeld && ((secondaryThumbstickVertical > 0.5f && beforeSecondaryThumbstickVertical <= 0.5f) || Input.GetKeyDown(KeyCode.M)))
                {
                    SyncedIsMenuActive = !SyncedIsMenuActive;
                }

                if (menuPickup.IsHeld)
                {
                    lastPlayerPosition = Networking.LocalPlayer.GetPosition();
                }

                if (SyncedIsMenuActive && !menuPickup.IsHeld && Vector3.Distance(lastPlayerPosition, Networking.LocalPlayer.GetPosition()) > 0.3f)
                {
                    SyncedIsMenuActive = false;
                }

                beforeSecondaryThumbstickVertical = secondaryThumbstickVertical;
            }
        }

        public bool IsRaycastMenu()
        {
            VRCPlayerApi.TrackingData headData = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.Head);
            Physics.Raycast(headData.position, headData.rotation * Vector3.forward, out RaycastHit hitInfo, 5.0f);
            return hitInfo.collider == menuDesktopCollider;
        }

        public bool SyncedIsMenuActive
        {
            set
            {
                if (syncedIsMenuActive != value)
                {
                    syncedIsMenuActive = value;

                    if (syncedIsMenuActive)
                    {
                        if (Networking.IsOwner(gameObject))
                        {
                            lastPlayerPosition = Networking.LocalPlayer.GetPosition();

                            VRCPlayerApi.TrackingData headData = Networking.GetOwner(gameObject).GetTrackingData(VRCPlayerApi.TrackingDataType.Head);
                            if (Networking.LocalPlayer.IsUserInVR())
                            {
                                menuTransform.position = (controller.penTipTransform.position - headData.position).normalized * 0.05f + controller.penTipTransform.position;
                                menuTransform.LookAt(menuTransform.position + headData.rotation * Vector3.forward);
                                menuTransform.position += menuTransform.right * 0.03f * menuTransform.localScale.x;
                                menuTransform.position += -menuTransform.up * 0.03f * menuTransform.localScale.x;
                            }
                            else
                            {
                                menuTransform.position = headData.position + headData.rotation * new Vector3(0.0f, 0.0f, 0.2f * menuTransform.localScale.x);
                                menuTransform.rotation = headData.rotation;
                            }
                        }
                    }
                    else
                    {
                        exportMenu.OnMenuClosed();
                    }
                }

                menuPickupCollider.enabled = Networking.IsOwner(gameObject) && syncedIsMenuActive;
                animator.SetBool("isOpen", syncedIsMenuActive);

                if (Networking.IsOwner(gameObject))
                {
                    RequestSerialization();
                }
            }
            get => syncedIsMenuActive;
        }
    }
}
