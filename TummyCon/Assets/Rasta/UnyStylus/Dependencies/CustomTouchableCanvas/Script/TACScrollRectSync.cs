
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus.CustomTouchableCanvas
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.Continuous)]
    [RequireComponent(typeof(UnityEngine.UI.ScrollRect))]
    public class TACScrollRectSync : UdonSharpBehaviour
    {
        [UdonSynced(UdonSyncMode.Smooth)] private Vector2 scrollRectPosition;

        private RectTransform scrollRectContentRTF;

        private void Start()
        {
            UnityEngine.UI.ScrollRect sr = GetComponent<UnityEngine.UI.ScrollRect>();
            scrollRectContentRTF = sr.viewport.GetChild(0).GetComponent<RectTransform>();

            if (!Utilities.IsValid(scrollRectContentRTF))
            {
                this.enabled = false;
            }
        }

        private void Update()
        {
            if (Networking.IsOwner(gameObject))
            {
                scrollRectPosition = scrollRectContentRTF.localPosition;
            }
            else
            {
                scrollRectContentRTF.localPosition = scrollRectPosition;
            }
        }
    }
}