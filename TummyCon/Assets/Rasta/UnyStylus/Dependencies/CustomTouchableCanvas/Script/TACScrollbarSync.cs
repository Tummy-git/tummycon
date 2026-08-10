
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus.CustomTouchableCanvas
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.Continuous)]
    [RequireComponent(typeof(UnityEngine.UI.Scrollbar))]
    public class TACScrollbarSync : UdonSharpBehaviour
    {
        [UdonSynced(UdonSyncMode.Smooth)] private float scrollbarValue;

        private Scrollbar scrollbar;

        void Start()
        {
            scrollbar = GetComponent<Scrollbar>();
        }

        private void Update()
        {
            if (Networking.IsOwner(gameObject))
            {
                scrollbarValue = scrollbar.value;
            }
            else
            {
                scrollbar.value = scrollbarValue;
            }
        }
    }
}