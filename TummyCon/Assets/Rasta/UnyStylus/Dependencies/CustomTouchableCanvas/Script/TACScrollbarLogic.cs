
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.UI;
using UnityEngine.EventSystems;

namespace Rasta.UnyStylus.CustomTouchableCanvas
{
    public class TACScrollbarLogic : UdonSharpBehaviour
    {

        public static TACScrollbarLogic New(int sphereCount)
        {
            Scrollbar[] scrollbars = new Scrollbar[sphereCount];
            RectTransform[] targetRTfs = new RectTransform[sphereCount];
            float[] dragStartPointerNormalizedVal = new float[sphereCount];
            float[] dragStartSliderNormalizedValue = new float[sphereCount];

            object[] buff = new object[]
            {
                scrollbars,
                targetRTfs,
                dragStartPointerNormalizedVal,
                dragStartSliderNormalizedValue
            };

            return (TACScrollbarLogic)(object)buff;
        }
    }

    public static class TAC_ScrollbarLogic_Extensions
    {
        public static Scrollbar GetScrollbar(this TACScrollbarLogic tac_scrollbar, int n)
        {
            return ((Scrollbar[])((object[])(object)tac_scrollbar)[0])[n];
        }

        private static void SetScrollbar(this TACScrollbarLogic tac_scrollbar, int n, Scrollbar scrollbar)
        {
            ((Scrollbar[])((object[])(object)tac_scrollbar)[0])[n] = scrollbar;
        }

        private static RectTransform GetTargetRTf(this TACScrollbarLogic tac_scrollbar, int n)
        {
            return ((RectTransform[])((object[])(object)tac_scrollbar)[1])[n];
        }

        private static void SetTargetRTf(this TACScrollbarLogic tac_scrollbar, int n, RectTransform hitRTf)
        {
            ((Transform[])((object[])(object)tac_scrollbar)[1])[n] = hitRTf;
        }

        private static float GetDragStartPointerNormalizedVal(this TACScrollbarLogic tac_scrollbar, int n)
        {
            return ((float[])((object[])(object)tac_scrollbar)[2])[n];
        }

        private static void SetDragStartPointerNormalizedVal(this TACScrollbarLogic tac_scrollbar, int n, float normalizedVal)
        {
            ((float[])((object[])(object)tac_scrollbar)[2])[n] = normalizedVal;
        }

        private static float GetDragStartScrollbarNormalizedVal(this TACScrollbarLogic tac_scrollbar, int n)
        {
            return ((float[])((object[])(object)tac_scrollbar)[3])[n];
        }

        private static void SetDragStartScrollbarNormalizedVal(this TACScrollbarLogic tac_scrollbar, int n, float normalizedVal)
        {
            ((float[])((object[])(object)tac_scrollbar)[3])[n] = normalizedVal;
        }

        private static float CalcNormalizedVal(this TACScrollbarLogic tac_scrollbar, int n, Vector3 pointerWorldPos)
        {
            Scrollbar scrollbar = tac_scrollbar.GetScrollbar(n);
            if (Utilities.IsValid(scrollbar))
            {
                RectTransform targetRect = tac_scrollbar.GetTargetRTf(n);
                if (Utilities.IsValid(targetRect))
                {
                    Vector2 pointerLocalPos = targetRect.InverseTransformPoint(pointerWorldPos);
                    switch (scrollbar.direction)
                    {
                        case Scrollbar.Direction.LeftToRight:
                            return pointerLocalPos.x / targetRect.rect.width * (scrollbar.size == 1 ? 0 : 1.0f / (1 - scrollbar.size)) + 0.5f;
                        case Scrollbar.Direction.RightToLeft:
                            return -pointerLocalPos.x / targetRect.rect.width * (scrollbar.size == 1 ? 0 : 1.0f / (1 - scrollbar.size)) + 0.5f;
                        case Scrollbar.Direction.TopToBottom:
                            return pointerLocalPos.y / targetRect.rect.height * (scrollbar.size == 1 ? 0 : 1.0f / (1 - scrollbar.size)) + 0.5f;
                        case Scrollbar.Direction.BottomToTop:
                            return -pointerLocalPos.y / targetRect.rect.height * (scrollbar.size == 1 ? 0 : 1.0f / (1 - scrollbar.size)) + 0.5f;
                    }
                }
            }
            return 0;
        }


        public static void Init(this TACScrollbarLogic tac_scrollbar, int n, Scrollbar scrollbar, GameObject hit, Vector3 pointerWorldPos)
        {
            tac_scrollbar.Clear(n);

            tac_scrollbar.SetScrollbar(n, scrollbar);

            if (Utilities.IsValid(scrollbar))
            {
                if (Utilities.IsValid(scrollbar.handleRect) && Utilities.IsValid(scrollbar.handleRect.parent))
                {
                    tac_scrollbar.SetTargetRTf(n, (RectTransform)scrollbar.handleRect.parent);

                    if (Utilities.IsValid(hit) && hit == scrollbar.handleRect.gameObject)
                    {
                        tac_scrollbar.SetDragStartScrollbarNormalizedVal(n, scrollbar.value);
                    }
                    else
                    {
                        float targetVal = tac_scrollbar.CalcNormalizedVal(n, pointerWorldPos);
                        if (targetVal > scrollbar.value)
                        {
                            targetVal = Mathf.Clamp01(targetVal - scrollbar.size * 0.5f);
                        }
                        else
                        {
                            targetVal = Mathf.Clamp01(targetVal + scrollbar.size * 0.5f);
                        }
                        tac_scrollbar.SetDragStartScrollbarNormalizedVal(n, targetVal);
                    }
                    tac_scrollbar.SetDragStartPointerNormalizedVal(n, tac_scrollbar.CalcNormalizedVal(n, pointerWorldPos));
                }
            }
        }

        public static void Clear(this TACScrollbarLogic tac_scrollbar, int n)
        {
            tac_scrollbar.SetScrollbar(n, null);
            tac_scrollbar.SetTargetRTf(n, null);
            tac_scrollbar.SetDragStartPointerNormalizedVal(n, 0);
            tac_scrollbar.SetDragStartScrollbarNormalizedVal(n, 0);
        }


        public static void OnBeginDrag(this TACScrollbarLogic tac_scrollbar, int n, PointerEventData pointerEventData)
        {
            Scrollbar scrollbar = tac_scrollbar.GetScrollbar(n);
            if (Utilities.IsValid(scrollbar))
            {
                scrollbar.OnBeginDrag(pointerEventData);
            }
        }

        public static void OnDrag(this TACScrollbarLogic tac_scrollbar, int n, Vector3 pointerWorldPos, PointerEventData pointerEventData)
        {
            Scrollbar scrollbar = tac_scrollbar.GetScrollbar(n);
            if (Utilities.IsValid(scrollbar))
            {
                scrollbar.OnDrag(pointerEventData);

                if (Utilities.IsValid(tac_scrollbar.GetTargetRTf(n)))
                {
                    float pointerNormalizedVal = tac_scrollbar.CalcNormalizedVal(n, pointerWorldPos);
                    float dragStartPointerNormalizedVal = tac_scrollbar.GetDragStartPointerNormalizedVal(n);
                    float normalizedDelta = pointerNormalizedVal - dragStartPointerNormalizedVal;
                    scrollbar.value = Mathf.Clamp01(tac_scrollbar.GetDragStartScrollbarNormalizedVal(n) + normalizedDelta);
                }
            }
        }
    }
}