
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDKBase;
using VRC.Udon;


namespace Rasta.UnyStylus.CustomTouchableCanvas
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.Continuous)]
    [RequireComponent(typeof(UnityEngine.UI.Slider))]
    public class TACSliderSync : UdonSharpBehaviour
    {
        [UdonSynced(UdonSyncMode.Smooth)] private float normalizedValue;

        private Slider slider;

        private void Start()
        {
            slider = GetComponent<Slider>();
        }

        private void Update()
        {
            if (Networking.IsOwner(gameObject))
            {
                normalizedValue = slider.normalizedValue;
            }
            else
            {
                slider.normalizedValue = normalizedValue;
            }
        }
    }
}