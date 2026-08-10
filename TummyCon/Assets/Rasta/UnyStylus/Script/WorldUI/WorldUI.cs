
using System;
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    public class WorldUI : UdonSharpBehaviour
    {
        [SerializeField] private UnyStylusController unyStylusController;
        [SerializeField] private RectTransform yesTransform;
        [SerializeField] private Animator animator;
        [SerializeField] private Toggle quickCallToggle;

        private bool isPointerDown = false;
        private DateTime lastPointerDownTime = DateTime.MinValue;

        [HideInInspector] public bool isEnableQuickCall = true;

        public void OpenPopup()
        {
            animator.SetBool("isOpen", true);
        }

        public void ClosePopup()
        {
            animator.SetBool("isOpen", false);
        }

        public void ClearPointerDown()
        {
            isPointerDown = true;
            SetLocalScaleX(0);
            lastPointerDownTime = DateTime.Now;
        }

        public void ClearPointerUp()
        {
            isPointerDown = false;
            SetLocalScaleX(0);
        }

        void Update()
        {
            if (isPointerDown)
            {
                float diff = (float)(DateTime.Now - lastPointerDownTime).TotalSeconds;
                SetLocalScaleX(Mathf.Clamp01(diff / 1.0f));
                if (diff >= 1.0f)
                {
                    isPointerDown = false;
                    ClosePopup();
                    SetLocalScaleX(0);
                    unyStylusController.linePool.SendCustomNetworkEvent(
                        VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                        nameof(LinePool.RemoveAllLines)
                    );
                }
            }
        }

        private void SetLocalScaleX(float x)
        {
            Vector3 scale = yesTransform.localScale;
            scale.x = x;
            yesTransform.localScale = scale;
        }

        // QuickCall
        public void SetEnableQuickCall(bool isEnable)
        {
            isEnableQuickCall = isEnable;
            quickCallToggle.SetIsOnWithoutNotify(isEnableQuickCall);
        }

        public void OnQuickCallToggleChanged()
        {
            isEnableQuickCall = quickCallToggle.isOn;
        }
    }
}
