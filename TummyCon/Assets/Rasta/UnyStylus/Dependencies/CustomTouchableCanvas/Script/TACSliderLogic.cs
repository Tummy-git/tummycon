
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.UI;
using UnityEngine.EventSystems;

namespace Rasta.UnyStylus.CustomTouchableCanvas
{
    public class TACSliderLogic : UdonSharpBehaviour
    {

        public static TACSliderLogic New(int sphereCount)
        {
            Slider[] sliders = new Slider[sphereCount];
            RectTransform[] hitRTfs = new RectTransform[sphereCount];
            float[] dragStartPointerNormalizedVal = new float[sphereCount];
            float[] dragStartSliderNormalizedValue = new float[sphereCount];

            object[] buff = new object[]
            {
                sliders,
                hitRTfs,
                dragStartPointerNormalizedVal,
                dragStartSliderNormalizedValue
            };

            return (TACSliderLogic)(object)buff;
        }
    }

    public static class TAC_Slider_Extensions
    {
        public static Slider GetSlider(this TACSliderLogic tac_slider, int n)
        {
            return ((Slider[])((object[])(object)tac_slider)[0])[n];
        }

        private static void SetSlider(this TACSliderLogic tac_slider, int n, Slider slider)
        {
            ((Slider[])((object[])(object)tac_slider)[0])[n] = slider;
        }

        private static RectTransform GetTargetRTf(this TACSliderLogic tac_slider, int n)
        {
            return ((RectTransform[])((object[])(object)tac_slider)[1])[n];
        }

        private static void SetTargetRTf(this TACSliderLogic tac_slider, int n, RectTransform targetRTf)
        {
            ((Transform[])((object[])(object)tac_slider)[1])[n] = targetRTf;
        }

        private static float GetDragStartPointerNormalizedVal(this TACSliderLogic tac_slider, int n)
        {
            return ((float[])((object[])(object)tac_slider)[2])[n];
        }

        private static void SetDragStartPointerNormalizedVal(this TACSliderLogic tac_slider, int n, float normalizedVal)
        {
            ((float[])((object[])(object)tac_slider)[2])[n] = normalizedVal;
        }

        private static float GetDragStartSliderNormalizedVal(this TACSliderLogic tac_slider, int n)
        {
            return ((float[])((object[])(object)tac_slider)[3])[n];
        }

        private static void SetDragStartSliderNormalizedVal(this TACSliderLogic tac_slider, int n, float normalizedVal)
        {
            ((float[])((object[])(object)tac_slider)[3])[n] = normalizedVal;
        }

        private static float CalcNormalizedVal(this TACSliderLogic tac_slider, int n, Vector3 pointerWorldPos)
        {
            Slider slider = tac_slider.GetSlider(n);
            if (Utilities.IsValid(slider))
            {
                RectTransform targetRect = tac_slider.GetTargetRTf(n);
                if (Utilities.IsValid(targetRect))
                {
                    Vector2 pointerLocalPos = targetRect.InverseTransformPoint(pointerWorldPos);
                    switch (slider.direction)
                    {
                        case Slider.Direction.LeftToRight:
                            return pointerLocalPos.x / targetRect.rect.width + 0.5f;
                        case Slider.Direction.RightToLeft:
                            return -pointerLocalPos.x / targetRect.rect.width + 0.5f;
                        case Slider.Direction.BottomToTop:
                            return pointerLocalPos.y / targetRect.rect.height + 0.5f;
                        case Slider.Direction.TopToBottom:
                            return -pointerLocalPos.y / targetRect.rect.height + 0.5f;
                    }
                }
            }
            return 0;
        }




        public static void Init(this TACSliderLogic tac_slider, int n, Slider slider, GameObject hit, Vector3 pointerWorldPos)
        {
            tac_slider.Clear(n);

            tac_slider.SetSlider(n, slider);

            if (Utilities.IsValid(slider))
            {
                bool isFindHandle = false;
                bool isFindRect = false;

                if (Utilities.IsValid(slider.handleRect) && Utilities.IsValid(slider.handleRect.parent))
                {
                    tac_slider.SetTargetRTf(n, slider.handleRect.parent.GetComponent<RectTransform>());
                    isFindHandle = true;
                    isFindRect = true;
                }
                else if (Utilities.IsValid(slider.fillRect) && Utilities.IsValid(slider.fillRect.parent))
                {
                    tac_slider.SetTargetRTf(n, slider.fillRect.parent.GetComponent<RectTransform>());
                    isFindRect = true;
                }

                if (isFindRect)
                {
                    if (isFindHandle && Utilities.IsValid(hit) && hit == slider.handleRect.gameObject)
                    {
                        tac_slider.SetDragStartSliderNormalizedVal(n, slider.normalizedValue);
                    }
                    else
                    {
                        tac_slider.SetDragStartSliderNormalizedVal(n, tac_slider.CalcNormalizedVal(n, pointerWorldPos));
                    }
                    tac_slider.SetDragStartPointerNormalizedVal(n, tac_slider.CalcNormalizedVal(n, pointerWorldPos));
                }
            }
        }

        public static void Clear(this TACSliderLogic tac_slider, int n)
        {
            tac_slider.SetSlider(n, null);
            tac_slider.SetTargetRTf(n, null);
            tac_slider.SetDragStartPointerNormalizedVal(n, 0);
            tac_slider.SetDragStartSliderNormalizedVal(n, 0);
        }

        public static void OnDrag(this TACSliderLogic tac_slider, int n, Vector3 pointerWorldPos, PointerEventData pointerEventData)
        {
            Slider slider = tac_slider.GetSlider(n);
            if (Utilities.IsValid(slider))
            {
                slider.OnDrag(pointerEventData);

                if (Utilities.IsValid(tac_slider.GetTargetRTf(n)))
                {
                    float pointerNormalizedVal = tac_slider.CalcNormalizedVal(n, pointerWorldPos);
                    float dragStartPointerNormalizedVal = tac_slider.GetDragStartPointerNormalizedVal(n);
                    float normalizedDelta = pointerNormalizedVal - dragStartPointerNormalizedVal;
                    slider.normalizedValue = Mathf.Clamp01(tac_slider.GetDragStartSliderNormalizedVal(n) + normalizedDelta);
                }
            }
        }
    }
}