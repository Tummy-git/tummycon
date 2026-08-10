
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.UI;
using UnityEngine.EventSystems;

namespace Rasta.UnyStylus.CustomTouchableCanvas
{
    public class TACScrollRectLogic : UdonSharpBehaviour
    {

        public static TACScrollRectLogic New(int sphereCount)
        {
            ScrollRect[] scrollRects = new ScrollRect[sphereCount];
            Vector2[] dragStartPointerPos = new Vector2[sphereCount];
            Vector2[] dragStartContentPos = new Vector2[sphereCount];

            object[] buff = new object[]
            {
                scrollRects,
                dragStartPointerPos,
                dragStartContentPos
            };

            return (TACScrollRectLogic)(object)buff;
        }
    }

    public static class TAC_ScrollRectLogic_Extensions
    {
        public static ScrollRect GetScrollRect(this TACScrollRectLogic tac_scrollRect, int n)
        {
            return ((ScrollRect[])((object[])(object)tac_scrollRect)[0])[n];
        }

        private static void SetScrollRect(this TACScrollRectLogic tac_scrollRect, int n, ScrollRect scrollRect)
        {
            ((ScrollRect[])((object[])(object)tac_scrollRect)[0])[n] = scrollRect;
        }

        private static Vector2 GetDragStartPointerPos(this TACScrollRectLogic tac_scrollRect, int n)
        {
            return ((Vector2[])((object[])(object)tac_scrollRect)[1])[n];
        }

        private static void SetDragStartPointerPos(this TACScrollRectLogic tac_scrollRect, int n, Vector2 pointerPos)
        {
            ((Vector2[])((object[])(object)tac_scrollRect)[1])[n] = pointerPos;
        }

        private static Vector2 GetDragStartContentPos(this TACScrollRectLogic tac_scrollRect, int n)
        {
            return ((Vector2[])((object[])(object)tac_scrollRect)[2])[n];
        }

        private static void SetDragStartContentPos(this TACScrollRectLogic tac_scrollRect, int n, Vector2 contentPos)
        {
            ((Vector2[])((object[])(object)tac_scrollRect)[2])[n] = contentPos;
        }





        public static void Init(this TACScrollRectLogic tac_scrollRect, int n, ScrollRect scrollRect, Selectable hitSelectable, Vector3 pointerWorldPos)
        {
            tac_scrollRect.Clear(n);

            tac_scrollRect.SetScrollRect(n, scrollRect);

            if (Utilities.IsValid(scrollRect) && Utilities.IsValid(scrollRect.content) && Utilities.IsValid(scrollRect.viewport))
            {
                if (!Utilities.IsValid(hitSelectable) || (Utilities.IsValid(hitSelectable) && hitSelectable.gameObject == scrollRect.gameObject))
                {
                    SetDragStartContentPos(tac_scrollRect, n, scrollRect.content.anchoredPosition);
                    SetDragStartPointerPos(tac_scrollRect, n, scrollRect.viewport.InverseTransformPoint(pointerWorldPos));
                }
            }
        }

        public static void Clear(this TACScrollRectLogic tac_scrollRect, int n)
        {
            tac_scrollRect.SetScrollRect(n, null);
            tac_scrollRect.SetDragStartPointerPos(n, Vector2.zero);
            tac_scrollRect.SetDragStartContentPos(n, Vector2.zero);
        }

        public static void OnBeginDrag(this TACScrollRectLogic tac_scrollRect, int n, PointerEventData pointerEventData)
        {
            ScrollRect scrollRect = tac_scrollRect.GetScrollRect(n);
            if (Utilities.IsValid(scrollRect))
            {
                scrollRect.OnBeginDrag(pointerEventData);
            }
        }

        public static void OnDrag(this TACScrollRectLogic tac_scrollRect, int n, Vector3 pointerWorldPos, PointerEventData pointerEventData)
        {
            ScrollRect scrollRect = tac_scrollRect.GetScrollRect(n);
            if (Utilities.IsValid(scrollRect) && Utilities.IsValid(scrollRect.content) && Utilities.IsValid(scrollRect.viewport))
            {
                Vector2 pointerPos = scrollRect.viewport.InverseTransformPoint(pointerWorldPos);
                Vector2 delta = pointerPos - tac_scrollRect.GetDragStartPointerPos(n);
                Vector2 startContentPos = tac_scrollRect.GetDragStartContentPos(n);

                Vector2 targetPos = startContentPos + delta;

                float xMin = scrollRect.content.rect.xMin * scrollRect.content.localScale.x + targetPos.x;
                float xMax = scrollRect.content.rect.xMax * scrollRect.content.localScale.x + targetPos.x;
                float yMin = scrollRect.content.rect.yMin * scrollRect.content.localScale.y + targetPos.y;
                float yMax = scrollRect.content.rect.yMax * scrollRect.content.localScale.y + targetPos.y;

                bool isXMin = xMin > 0;
                bool isXMax = xMax < scrollRect.viewport.rect.width;
                bool isYMin = yMin > -scrollRect.viewport.rect.height;
                bool isYMax = yMax < 0;

                float div = 3.0f;
                Vector2 add = Vector3.zero;
                if (scrollRect.content.rect.width * scrollRect.content.localScale.x <= scrollRect.viewport.rect.width)
                {
                    delta.x /= div;
                } 
                else if (isXMin ^ isXMax)
                {
                    add.x = (isXMin ? -xMin : scrollRect.viewport.rect.width - xMax) * (1 - 1 / div);
                }

                if (scrollRect.content.rect.height * scrollRect.content.localScale.y <= scrollRect.viewport.rect.height)
                {
                    delta.y /= div;
                }
                else if (isYMin ^ isYMax)
                {
                    add.y = (isYMin ? -scrollRect.viewport.rect.height - yMin : -yMax) * (1 - 1 / div);
                }

                scrollRect.OnDrag(pointerEventData);
                scrollRect.content.anchoredPosition = startContentPos + Vector2.Scale(delta + add, new Vector2(scrollRect.horizontal ? 1 : 0, scrollRect.vertical ? 1 : 0));
            }
        }

        public static void OnEndDrag(this TACScrollRectLogic tac_scrollRect, int n, PointerEventData pointerEventData)
        {
            ScrollRect scrollRect = tac_scrollRect.GetScrollRect(n);
            if (Utilities.IsValid(scrollRect))
            {
                scrollRect.OnEndDrag(pointerEventData);
            }
        }
    }
}