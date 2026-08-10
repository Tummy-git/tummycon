
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDK3.UdonNetworkCalling;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    public class PlayerPopup : UdonSharpBehaviour
    {
        [SerializeField] private Text playerNameText;
        [SerializeField] private Animator animator;
        [SerializeField] private GameObject popupObject;

        [NetworkCallable]
        public void NotifySaveAllStrokes(int playerId)
        {
            VRCPlayerApi player = VRCPlayerApi.GetPlayerById(playerId);
            if (Utilities.IsValid(player))
            {
                playerNameText.text = player.displayName;
                animator.Play("PlayerPopupOpen", 0, 0);
            }
        }

        void Update()
        {
            if (popupObject.activeSelf)
            {
                VRCPlayerApi.TrackingData headData = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.Head);
                transform.position = headData.position;
                transform.rotation = headData.rotation;
            }
        }
    }
}
