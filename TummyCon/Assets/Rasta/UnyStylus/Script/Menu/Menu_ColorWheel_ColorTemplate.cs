
using System;
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    public class Menu_ColorWheel_ColorTemplate : UdonSharpBehaviour
    {
        [SerializeField] private Menu_ColorWheel colorWheel;
        [SerializeField] private Image image;
        [SerializeField] private bool isSaveColor = false;
        [SerializeField] private Image circle;
        [SerializeField] private GameObject emptyMark;

        private bool isPressed = false;
        private DateTime lastPointerDownTime = DateTime.MinValue;

        public void OnPointerDown()
        {
            if (!isSaveColor) return;

            isPressed = true;
            circle.fillAmount = 0.0f;
            lastPointerDownTime = DateTime.Now;
        }

        public void OnPointerUp()
        {
            if (!isSaveColor) return;

            isPressed = false;
            circle.fillAmount = 0.0f;
        }

        void Update()
        {
            if (!isSaveColor) return;

            if (isPressed)
            {
                float diff = (float)(DateTime.Now - lastPointerDownTime).TotalSeconds;
                circle.fillAmount = Mathf.Clamp01(diff / 1.0f);
                if (diff >= 1.0f)
                {
                    isPressed = false;
                    circle.fillAmount = 0.0f;
                    image.color = colorWheel.SyncedLineColor;
                    emptyMark.SetActive(false);
                }
            }
        }

        public void OnClick()
        {
            if (!emptyMark.activeSelf)
                colorWheel.SyncedLineColor = image.color;
        }
    }
}
