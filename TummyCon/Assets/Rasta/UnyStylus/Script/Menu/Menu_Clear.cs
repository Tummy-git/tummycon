
using System;
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDK3.Components;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    public class Menu_Clear : UdonSharpBehaviour
    {
        [SerializeField] private UnyStylusController unyStylusController;
        [SerializeField] private VRCPickup pickup;
        [SerializeField] private Image circle;
        [SerializeField] private Menu_PenMode menu_PenMode;
        [SerializeField] private Text layerIdText;
        [Space(10)]
        [SerializeField] private Animator penPopupAnimator;
        [SerializeField] private Image penPopupCircle;

        private bool isPressed = false;
        private DateTime lastPressedTime = DateTime.MinValue;
        private bool showPopup = false;

        private float beforeSecondaryThumbstickVertical = 0.0f;

        private DateTime lastPointerUpTime = DateTime.MinValue;

        void Update()
        {
            if (Networking.IsOwner(gameObject))
            {
                float secondaryThumbstickVertical = Input.GetAxis("Oculus_CrossPlatform_SecondaryThumbstickVertical");
                if (pickup.IsHeld)
                {
                    if (secondaryThumbstickVertical < -0.5f && beforeSecondaryThumbstickVertical >= -0.5f)
                    {
                        isPressed = true;
                        lastPressedTime = DateTime.Now;
                        showPopup = true;
                    }
                    else if (secondaryThumbstickVertical > -0.5f && beforeSecondaryThumbstickVertical <= -0.5f)
                    {
                        isPressed = false;
                        circle.fillAmount = 0.0f;

                        // Undo
                        if ((DateTime.Now - lastPressedTime).TotalSeconds < 1.0f)
                        {
                            Networking.LocalPlayer.PlayHapticEventInHand(pickup.currentHand, 0.1f, 0.1f, 0.05f);
                            unyStylusController.linePool.SendCustomNetworkEvent(
                                VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                                nameof(LinePool.RemoveLine),
                                Networking.LocalPlayer.playerId,
                                unyStylusController.linePool.GetLastLineId(Networking.LocalPlayer.playerId)
                            );
                        }
                    }
                    
                }
                else
                {
                    isPressed = false;
                    circle.fillAmount = 0.0f;
                }
                beforeSecondaryThumbstickVertical = secondaryThumbstickVertical;

                if (isPressed)
                {
                    float diff = (float)(DateTime.Now - lastPressedTime).TotalSeconds;
                    circle.fillAmount = Mathf.Clamp01(diff / 1.0f);
                    penPopupCircle.fillAmount = Mathf.Clamp01(diff / 1.0f);
                    if (diff >= 1.0f)
                    {
                        isPressed = false;
                        circle.fillAmount = 0.0f;
                        Networking.LocalPlayer.PlayHapticEventInHand(pickup.currentHand, 0.1f, 0.1f, 0.05f);
                        unyStylusController.linePool.SendCustomNetworkEvent(
                            VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                            nameof(LinePool.RemoveSelfLines),
                            Networking.LocalPlayer.playerId,
                            menu_PenMode.SyncedLayerId
                        );
                    }
                }

                penPopupAnimator.SetBool("isShowUndoClear", showPopup && isPressed);
            }
        }

        public void OnPointerDown()
        {
            isPressed = true;
            showPopup = false;
            lastPressedTime = DateTime.Now;
        }

        public void OnPointerUp()
        {
            if ((DateTime.Now - lastPointerUpTime).TotalSeconds < 0.1f) return;

            lastPointerUpTime = DateTime.Now;

            isPressed = false;
            circle.fillAmount = 0.0f;

            // Undo
            if ((DateTime.Now - lastPressedTime).TotalSeconds < 1.0f)
            {
                unyStylusController.linePool.SendCustomNetworkEvent(
                    VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                    nameof(LinePool.RemoveLine),
                    Networking.LocalPlayer.playerId,
                    unyStylusController.linePool.GetLastLineId(Networking.LocalPlayer.playerId)
                );
            }
        }

        public void OnChangedLayerId()
        {
            layerIdText.text = (menu_PenMode.SyncedLayerId + 1).ToString();
        }
    }
}
