
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    public class PenPopup : UdonSharpBehaviour
    {
        [SerializeField] private Transform canvasParent;
        [SerializeField] private Animator animator;

        void Update()
        {
            Quaternion headRotation = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.Head).rotation;
            transform.LookAt(headRotation * Vector3.forward + transform.position);
            canvasParent.LookAt(headRotation * Vector3.forward + canvasParent.position);
        }

        public void OnUnyStylusPickup()
        {
            animator.SetBool("isShowMenuShortCut", true);
        }
    }
}
