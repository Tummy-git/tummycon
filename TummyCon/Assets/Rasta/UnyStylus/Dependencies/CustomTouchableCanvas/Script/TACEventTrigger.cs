using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus.CustomTouchableCanvas
{
    [DisallowMultipleComponent]
    public class TACEventTrigger : UdonSharpBehaviour
    {
        [SerializeField] public UdonBehaviour[] pointerDownUB;
        [SerializeField] public string[] pointerDownEventNames;

        [SerializeField] public UdonBehaviour[] pointerUpUB;
        [SerializeField] public string[] pointerUpEventNames;

        [SerializeField] public UdonBehaviour[] pointerClickUB;
        [SerializeField] public string[] pointerClickEventNames;

        [SerializeField] public UdonBehaviour[] beginDragUB;
        [SerializeField] public string[] beginDragEventNames;

        [SerializeField] public UdonBehaviour[] dragUB;
        [SerializeField] public string[] dragEventNames;

        [SerializeField] public UdonBehaviour[] endDragUB;
        [SerializeField] public string[] endDragEventNames;

        public void OnPointerDown()
        {
            triggerEvents(pointerDownUB, pointerDownEventNames);
        }

        public void OnPointerUp()
        {
            triggerEvents(pointerUpUB, pointerUpEventNames);
        }

        public void OnPointerClick()
        {
            triggerEvents(pointerClickUB, pointerClickEventNames);
        }

        public void OnBeginDrag()
        {
            triggerEvents(beginDragUB, beginDragEventNames);
        }

        public void OnDrag()
        {
            triggerEvents(dragUB, dragEventNames);
        }

        public void OnEndDrag()
        {
            triggerEvents(endDragUB, endDragEventNames);
        }

        private void triggerEvents(UdonBehaviour[] udonBehaviours, string[] eventNames)
        {
            if (!Utilities.IsValid(udonBehaviours) || !Utilities.IsValid(eventNames)) return;

            for (int i = 0; i < udonBehaviours.Length && i < eventNames.Length; i++)
            {
                if (Utilities.IsValid(udonBehaviours[i]) && !string.IsNullOrEmpty(eventNames[i]))
                {
                    udonBehaviours[i].SendCustomEvent(eventNames[i]);
                }
            }
        }
    }
}
