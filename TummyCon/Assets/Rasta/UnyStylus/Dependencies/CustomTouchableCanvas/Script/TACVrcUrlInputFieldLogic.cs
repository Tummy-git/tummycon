
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using VRC.SDK3.Components;
using VRC.SDK3.Data;

namespace Rasta.UnyStylus.CustomTouchableCanvas
{
    public class TACVrcUrlInputFieldLogic : UdonSharpBehaviour
    {

        public static TACVrcUrlInputFieldLogic New(int sphereCount)
        {
            VRCUrlInputField[] vrcURLInputFields = new VRCUrlInputField[sphereCount];

            object[] buff = new object[]
            {
                vrcURLInputFields
            };

            return (TACVrcUrlInputFieldLogic)(object)buff;
        }
    }

    public static class TAC_VRCUrlInputField_Extensions
    {

        public static VRCUrlInputField GetVRCUrlInputField(this TACVrcUrlInputFieldLogic tac_vrcURLInputField, int n)
        {
            return ((VRCUrlInputField[])((object[])(object)tac_vrcURLInputField)[0])[n];
        }

        public static void SetVRCUrlInputField(this TACVrcUrlInputFieldLogic tac_vrcURLInputField, int n, VRCUrlInputField vrcURLInputField)
        {
            ((VRCUrlInputField[])((object[])(object)tac_vrcURLInputField)[0])[n] = vrcURLInputField;
        }

        public static void ActivateInputField(this TACVrcUrlInputFieldLogic tac_vrcURLInputField, int n)
        {
            VRCUrlInputField vrcUrlInputField = tac_vrcURLInputField.GetVRCUrlInputField(n);
            if (Utilities.IsValid(vrcUrlInputField))
            {
                vrcUrlInputField.ActivateInputField();
            }
        }
    }
}