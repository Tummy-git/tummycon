
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.UI;
using UnityEngine.EventSystems;

namespace Rasta.UnyStylus.CustomTouchableCanvas
{

    public class TACDropdownLogic : UdonSharpBehaviour
    {

        public static TACDropdownLogic New(int sphereCount)
        {
            Dropdown[] dropdowns = new Dropdown[sphereCount];

            object[] buff = new object[]
            {
            dropdowns
            };

            return (TACDropdownLogic)(object)buff;
        }
    }

    public static class TAC_DropdownLogic_Extensions
    {
        public static Dropdown GetDropdown(this TACDropdownLogic tac_dropdown, int n)
        {
            return ((Dropdown[])((object[])(object)tac_dropdown)[0])[n];
        }

        public static void SetDropdown(this TACDropdownLogic tac_dropdown, int n, Dropdown dropdown)
        {
            ((Dropdown[])((object[])(object)tac_dropdown)[0])[n] = dropdown;
        }

        public static void OnPointerClick(this TACDropdownLogic tac_dropdown, int n, PointerEventData pointerEventData)
        {
            Dropdown dropdown = tac_dropdown.GetDropdown(n);
            if (Utilities.IsValid(dropdown))
            {
                dropdown.OnPointerClick(pointerEventData);
            }
        }
    }
}