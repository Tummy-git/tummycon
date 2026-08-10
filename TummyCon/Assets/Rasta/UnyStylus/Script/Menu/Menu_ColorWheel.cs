
using Rasta.UnyStylus.CustomTouchableCanvas;
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
    public class Menu_ColorWheel : UdonSharpBehaviour
    {
        [SerializeField] private Image[] colorImages;
        public Renderer[] colorRenderers;
        public Material[] colorMaterials;
        public LineRenderer[] colorLineRenderers;
        [Space(10)]
        [SerializeField] private UnyStylusController controller;
        [SerializeField] private CustomTouchableCanvas.TouchableCanvas touchableCanvas;
        [SerializeField] private RectTransform hsAreaTransform;
        [SerializeField] private float hsAreaLocalRadius = 0.1f;
        [SerializeField] private RectTransform hsHandleTransform;
        [SerializeField] private Slider valueSlider;
        [SerializeField] private Image colorWheel;
        [SerializeField] private Text colorCodeText;

        private bool isPointerPressed = false;

        [UdonSynced, FieldChangeCallback(nameof(SyncedLineColor))] private Color syncedLineColor = Color.white;

        void Update()
        {
            if (isPointerPressed)
            {
                HSVDrag();
            }
        }

        public void ValueSliderChanged()
        {
            Vector3 localPos = hsHandleTransform.anchoredPosition;
            float dist = localPos.magnitude;
            float hue = (Mathf.Atan2(-localPos.y, -localPos.x) + Mathf.PI) / (2.0f * Mathf.PI);
            float saturation = Mathf.Min(dist / hsAreaLocalRadius, 1.0f);
            float value = valueSlider.value / valueSlider.maxValue;
            SetHSV(hue, saturation, value);
        }

        public void ValueSliderEndDrag()
        {
            Vector3 localPos = hsHandleTransform.anchoredPosition;
            float dist = localPos.magnitude;
            float hue = (Mathf.Atan2(-localPos.y, -localPos.x) + Mathf.PI) / (2.0f * Mathf.PI);
            float saturation = Mathf.Min(dist / hsAreaLocalRadius, 1.0f);
            float value = valueSlider.value / valueSlider.maxValue;
            SetHSV(hue, saturation, value);
            SyncedLineColor = Color.HSVToRGB(hue, saturation, value);
        }

        public void PointerDown()
        {
            if (!isPointerPressed)
            {
                isPointerPressed = true;
                HSVDrag();
            }
        }

        public void PointerUp()
        {
            if (isPointerPressed)
            {
                isPointerPressed = false;
                HSVEndDrag();
            }
        }

        public void HSVDrag()
        {
            bool isTouched;
            Vector3 screenPos;
            Vector3 worldPos;
            if (Networking.LocalPlayer.IsUserInVR())
            {
                touchableCanvas.GetTouch(0, out isTouched, out screenPos, out worldPos);
            }
            else
            {
                isTouched = true;
                VRCPlayerApi.TrackingData headData = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.Head);
                Physics.Raycast(headData.position, headData.rotation * Vector3.forward, out RaycastHit hitInfo, 5.0f);
                worldPos = hitInfo.point;
            }

            if (isTouched)
            {
                float hue, saturation, value;
                GetHSV(worldPos, out hue, out saturation, out value);
                SetHSV(hue, saturation, value);
            }
        }

        public void HSVEndDrag()
        {
            float hue, saturation, value;
            GetHSV(hsHandleTransform.position, out hue, out saturation, out value);
            SetHSV(hue, saturation, value);
            SyncedLineColor = Color.HSVToRGB(hue, saturation, value);
        }

        private void GetHSV(Vector3 worldPos, out float h, out float s, out float v)
        {
            Vector3 localPos = hsAreaTransform.InverseTransformPoint(worldPos);
            float dist = localPos.magnitude;
            dist = Mathf.Min(dist, hsAreaLocalRadius);
            h = (Mathf.Atan2(-localPos.y, -localPos.x) + Mathf.PI) / (2.0f * Mathf.PI);
            s = Mathf.Min(dist / hsAreaLocalRadius, 1.0f);
            v = valueSlider.value / valueSlider.maxValue;
        }

        private void SetHSV(float h, float s, float v)
        {
            hsHandleTransform.anchoredPosition = new Vector3(
                Mathf.Cos(h * 2.0f * Mathf.PI),
                Mathf.Sin(h * 2.0f * Mathf.PI),
                0.0f
            ) * s * hsAreaLocalRadius;
            valueSlider.SetValueWithoutNotify(v * valueSlider.maxValue);

            Color col = Color.white * v;
            col.a = 1.0f;
            colorWheel.color = col;

            Color color = Color.HSVToRGB(h, s, v);
            colorCodeText.text = "#" + LinePool.ToHtmlStringRGBA(color).Substring(0, 6);
            colorCodeText.color = s < 0.25f && v > 0.75 ? Color.gray : Color.white;
            foreach (Image img in colorImages)
            {
                img.color = color;
            }
            foreach (Renderer rend in colorRenderers)
            {
                rend.material.color = color;
            }
            foreach (Material mat in colorMaterials)
            {
                mat.color = color;
            }
            foreach (LineRenderer lineRend in colorLineRenderers)
            {
                lineRend.startColor = color;
                lineRend.endColor = color;
            }
        }

        public void SetRGB(Color color)
        {
            float h, s, v;
            Color.RGBToHSV(color, out h, out s, out v);
            SetHSV(h, s, v);
        }

        public void UpdateColor()
        {
            SetRGB(SyncedLineColor);
        }


        public Color SyncedLineColor
        {
            set
            {
                if (syncedLineColor != value)
                {
                    syncedLineColor = value;
                    SetRGB(syncedLineColor);
                }

                if (Networking.IsOwner(gameObject))
                {
                    RequestSerialization();
                }
            }
            get => syncedLineColor;
        }
    }
}
