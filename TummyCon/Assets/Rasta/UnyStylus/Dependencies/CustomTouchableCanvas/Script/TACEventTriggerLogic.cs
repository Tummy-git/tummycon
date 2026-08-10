
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.UI;
using UnityEngine.EventSystems;

namespace Rasta.UnyStylus.CustomTouchableCanvas
{
    public class TACEventTriggerLogic : UdonSharpBehaviour
    {

        public static TACEventTriggerLogic New(int sphereCount)
        {
            TACEventTrigger[] eventTriggers = new TACEventTrigger[sphereCount];

            object[] buff = new object[]
            {
            eventTriggers
            };

            return (TACEventTriggerLogic)(object)buff;
        }
    }

    public static class TAC_EventTriggerLogic_Extensions
    {
        public static TACEventTrigger GetEventTrigger(this TACEventTriggerLogic tac_eventTrigger, int n)
        {
            return ((TACEventTrigger[])((object[])(object)tac_eventTrigger)[0])[n];
        }

        public static void SetEventTrigger(this TACEventTriggerLogic tac_eventTrigger, int n, TACEventTrigger eventTrigger)
        {
            ((TACEventTrigger[])((object[])(object)tac_eventTrigger)[0])[n] = eventTrigger;
        }




        public static void OnPointerDown(this TACEventTriggerLogic tac_eventTrigger, int n)
        {
            TACEventTrigger eventTrigger = tac_eventTrigger.GetEventTrigger(n);
            if (Utilities.IsValid(eventTrigger))
            {
                eventTrigger.OnPointerDown();
            }
        }

        public static void OnPointerUp(this TACEventTriggerLogic tac_eventTrigger, int n)
        {
            TACEventTrigger eventTrigger = tac_eventTrigger.GetEventTrigger(n);
            if (Utilities.IsValid(eventTrigger))
            {
                eventTrigger.OnPointerUp();
            }
        }

        public static void OnPointerClick(this TACEventTriggerLogic tac_eventTrigger, int n)
        {
            TACEventTrigger eventTrigger = tac_eventTrigger.GetEventTrigger(n);
            if (Utilities.IsValid(eventTrigger))
            {
                eventTrigger.OnPointerClick();
            }
        }

        public static void OnBeginDrag(this TACEventTriggerLogic tac_eventTrigger, int n)
        {
            TACEventTrigger eventTrigger = tac_eventTrigger.GetEventTrigger(n);
            if (Utilities.IsValid(eventTrigger))
            {
                eventTrigger.OnBeginDrag();
            }
        }

        public static void OnDrag(this TACEventTriggerLogic tac_eventTrigger, int n)
        {
            TACEventTrigger eventTrigger = tac_eventTrigger.GetEventTrigger(n);
            if (Utilities.IsValid(eventTrigger))
            {
                eventTrigger.OnDrag();
            }
        }

        public static void OnEndDrag(this TACEventTriggerLogic tac_eventTrigger, int n)
        {
            TACEventTrigger eventTrigger = tac_eventTrigger.GetEventTrigger(n);
            if (Utilities.IsValid(eventTrigger))
            {
                eventTrigger.OnEndDrag();
            }
        }
    }
}