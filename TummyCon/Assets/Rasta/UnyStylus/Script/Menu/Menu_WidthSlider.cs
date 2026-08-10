
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    public class Menu_WidthSlider : UdonSharpBehaviour
    {
        [SerializeField] private UnyStylus unyStylus;
        [SerializeField] private Menu_PenMode penModeMenu;
        [SerializeField] private Eraser unyStylusEraser;
        [SerializeField] private float minWidth = 0.001f;
        [SerializeField] private float maxWidth = 0.05f;
        [SerializeField] private Slider widthSlider;
        [SerializeField] private Text widthText;
        [SerializeField] private Transform menuTransform;
        [SerializeField] private Transform canvasTransform;
        [SerializeField] private Transform previewSphere;
        [SerializeField] private Transform previewCube;

        [UdonSynced, FieldChangeCallback(nameof(SyncedLineWidth))] private float syncedLineWidth = 0.0f;
        [UdonSynced, FieldChangeCallback(nameof(SyncedEraserWidth))] private float syncedEraserWidth = 0.0f;

        void Start()
        {
            if (Networking.IsOwner(gameObject))
            {
                SyncedLineWidth = widthFromSliderValue(unyStylus.defaultLineWidth);
                SyncedEraserWidth = widthFromSliderValue(unyStylus.defaultEraserWidth);
            }
        }

        public void OnChangedPenMode()
        {
            if (penModeMenu.SyncedPenMode == (int)UnyStylusMode.Erase)
            {
                widthSlider.value = sliderValueFromWidth(SyncedEraserWidth);
                widthText.text = widthSlider.value.ToString("F0");
                previewSphere.gameObject.SetActive(false);
                previewCube.gameObject.SetActive(true);
            }
            else
            {
                widthSlider.value = sliderValueFromWidth(SyncedLineWidth);
                widthText.text = widthSlider.value.ToString("F0");
                previewSphere.gameObject.SetActive(true);
                previewCube.gameObject.SetActive(false);
            }
        }

        public void OnValueChanged()
        {
            if (penModeMenu.SyncedPenMode == (int)UnyStylusMode.Erase)
            {
                SyncedEraserWidth = widthFromSliderValue(widthSlider.value);
                widthText.text = widthSlider.value.ToString("F0");
            }
            else
            {
                SyncedLineWidth = widthFromSliderValue(widthSlider.value);
                widthText.text = widthSlider.value.ToString("F0");
            }
        }

        public float SyncedLineWidth
        {
            set
            {
                syncedLineWidth = value;

                if (penModeMenu.SyncedPenMode != (int)UnyStylusMode.Erase)
                {
                    widthSlider.SetValueWithoutNotify(sliderValueFromWidth(syncedLineWidth));
                    widthText.text = widthSlider.value.ToString("F0");
                }

                if (previewSphere.parent.lossyScale.x > 0f)
                    previewSphere.localScale = Vector3.one * (syncedLineWidth / (menuTransform.lossyScale.x * canvasTransform.localScale.x));

                if (Networking.IsOwner(gameObject))
                {
                    RequestSerialization();
                }
            }
            get => syncedLineWidth;
        }

        public float SyncedEraserWidth
        {
            set
            {
                syncedEraserWidth = value;

                if (penModeMenu.SyncedPenMode == (int)UnyStylusMode.Erase)
                {
                    widthSlider.SetValueWithoutNotify(sliderValueFromWidth(syncedEraserWidth));
                    widthText.text = widthSlider.value.ToString("F0");
                }
                
                if (previewCube.parent.lossyScale.x > 0f)
                    previewCube.localScale = Vector3.one * (syncedEraserWidth / (menuTransform.lossyScale.x * canvasTransform.localScale.x));

                unyStylusEraser.OnSizeChanged();

                if (Networking.IsOwner(gameObject))
                {
                    RequestSerialization();
                }
            }
            get => syncedEraserWidth;
        }

        public override void OnAvatarEyeHeightChanged(VRCPlayerApi player, float prevEyeHeightAsMeters)
        {
            if (player.playerId == Networking.GetOwner(gameObject).playerId)
            {
                previewSphere.localScale = Vector3.one * (SyncedLineWidth / (menuTransform.lossyScale.x * canvasTransform.localScale.x));
                previewCube.localScale = Vector3.one * (SyncedEraserWidth / (menuTransform.lossyScale.x * canvasTransform.localScale.x));
                unyStylusEraser.OnSizeChanged();
            }
        }


        private float widthFromSliderValue(float sliderValue)
        {
            float normalized = sliderValue / widthSlider.maxValue;
            float x2 = normalized * normalized;
            return Mathf.Lerp(minWidth, maxWidth, x2);
        }

        private float sliderValueFromWidth(float lineWidth)
        {
            float normalized = (lineWidth - minWidth) / (maxWidth - minWidth);
            float x = Mathf.Sqrt(normalized);
            return x * widthSlider.maxValue;
        }
    }
}
