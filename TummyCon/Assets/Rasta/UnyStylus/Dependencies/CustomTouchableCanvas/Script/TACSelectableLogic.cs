
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.UI;
using UnityEngine.EventSystems;

namespace Rasta.UnyStylus.CustomTouchableCanvas
{
    public class TACSelectableLogic
    {
        public static TACSelectableLogic New(int sphereCount)
        {
            Selectable[] selectables = new Selectable[sphereCount];

            object[] buff = new object[]
            {
            selectables
            };

            return (TACSelectableLogic)(object)buff;
        }
    }

    public static class TAC_SelectableLogic_Extensions
    {

        public static Selectable GetSelectable(this TACSelectableLogic tac_selectable, int n)
        {
            return ((Selectable[])((object[])(object)tac_selectable)[0])[n];
        }

        private static void SetSelectable(this TACSelectableLogic tac_selectable, int n, Selectable selectable)
        {
            ((Selectable[])((object[])(object)tac_selectable)[0])[n] = selectable;
        }


        public static void Init(this TACSelectableLogic tac_selectable, int n, Selectable selectable)
        {
            tac_selectable.Clear(n);

            tac_selectable.SetSelectable(n, selectable);
        }

        public static void Clear(this TACSelectableLogic tac_selectable, int n)
        {
            tac_selectable.SetSelectable(n, null);
        }

        public static void OnPointerDown(this TACSelectableLogic tac_selectable, int n, PointerEventData pointerEventData)
        {
            Selectable selectable = tac_selectable.GetSelectable(n);
            if (Utilities.IsValid(selectable))
            {
                selectable.OnPointerDown(pointerEventData);
            }
        }

        public static void OnPointerUp(this TACSelectableLogic tac_selectable, int n, PointerEventData pointerEventData)
        {
            Selectable selectable = tac_selectable.GetSelectable(n);
            if (Utilities.IsValid(selectable))
            {
                selectable.OnPointerUp(pointerEventData);
            }
        }
    }
}