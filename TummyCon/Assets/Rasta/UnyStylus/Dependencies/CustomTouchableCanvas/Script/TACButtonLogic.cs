
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.UI;
using UnityEngine.EventSystems;

namespace Rasta.UnyStylus.CustomTouchableCanvas
{
    public class TACButtonLogic : UdonSharpBehaviour
    {

        public static TACButtonLogic New(int sphereCount)
        {
            Button[] buttons = new Button[sphereCount];

            object[] buff = new object[]
            {
            buttons
            };

            return (TACButtonLogic)(object)buff;
        }
    }

    public static class TAC_ButtonLogic_Extensions
    {
        public static Button GetButton(this TACButtonLogic tac_button, int n)
        {
            return ((Button[])((object[])(object)tac_button)[0])[n];
        }

        private static void SetButton(this TACButtonLogic tac_button, int n, Button button)
        {
            ((Button[])((object[])(object)tac_button)[0])[n] = button;
        }

        public static void Init(this TACButtonLogic tac_button, int n, Button button)
        {
            tac_button.Clear(n);

            tac_button.SetButton(n, button);
        }

        public static void Clear(this TACButtonLogic tac_button, int n)
        {
            tac_button.SetButton(n, null);
        }

        public static void OnPointerClick(this TACButtonLogic tac_button, int n, PointerEventData pointerEventData)
        {
            Button button = tac_button.GetButton(n);
            if (Utilities.IsValid(button))
            {
                button.OnPointerClick(pointerEventData);
            }
        }
    }
}