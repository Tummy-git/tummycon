
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.UI;
using UnityEngine.EventSystems;

namespace Rasta.UnyStylus.CustomTouchableCanvas
{
    public class TACToggleLogic
    {
        public static TACToggleLogic New(int sphereCount)
        {
            Toggle[] toggles = new Toggle[sphereCount];

            object[] buff = new object[]
            {
            toggles
            };

            return (TACToggleLogic)(object)buff;
        }
    }

    public static class TAC_ToggleLogic_Extensions
    {

        public static Toggle GetToggle(this TACToggleLogic tac_toggle, int n)
        {
            return ((Toggle[])((object[])(object)tac_toggle)[0])[n];
        }

        private static void SetToggle(this TACToggleLogic tac_toggle, int n, Toggle toggle)
        {
            ((Toggle[])((object[])(object)tac_toggle)[0])[n] = toggle;
        }


        public static void Init(this TACToggleLogic tac_toggle, int n, Toggle toggle)
        {
            tac_toggle.Clear(n);

            tac_toggle.SetToggle(n, toggle);
        }

        public static void Clear(this TACToggleLogic tac_toggle, int n)
        {
            tac_toggle.SetToggle(n, null);
        }

        public static void OnPointerClick(this TACToggleLogic tac_toggle, int n, PointerEventData pointerEventData)
        {
            Toggle toggle = tac_toggle.GetToggle(n);
            if (Utilities.IsValid(toggle))
            {
                toggle.OnPointerClick(pointerEventData);
            }
        }
    }
}