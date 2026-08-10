
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    public class Eraser : UdonSharpBehaviour
    {
        [SerializeField] UnyStylusController unyStylusController;
        [SerializeField] private PenMenu penMenu;
        [SerializeField] private Menu_PenMode penModeMenu;
        [SerializeField] private Menu_WidthSlider widthSliderMenu;
        [SerializeField] private Collider eraserCollider;
        [SerializeField] private Renderer eraserRenderer;

        public void OnChangedPenMode()
        {
            int penMode = penModeMenu.SyncedPenMode;
            eraserRenderer.enabled = penMode == (int)UnyStylusMode.Erase;
            if (penMode != (int)UnyStylusMode.Erase)
            {
                Erase(false);
            }
        }

        public void OnUnyStylusPickupUseDown()
        {
            if (penModeMenu.SyncedPenMode != (int)UnyStylusMode.Erase) return;
            if (!Networking.LocalPlayer.IsUserInVR() && penMenu.IsRaycastMenu()) return;
            Erase(true);
        }

        public void OnUnyStylusPickupUseUp()
        {
            if (penModeMenu.SyncedPenMode != (int)UnyStylusMode.Erase) return;
            // if (!Networking.LocalPlayer.IsUserInVR() && penMenu.IsRaycastMenu()) return;
            Erase(false);
        }

        public void OnUnyStylusDrop()
        {
            if (penModeMenu.SyncedPenMode != (int)UnyStylusMode.Erase) return;
            Erase(false);
        }

        public void Erase(bool isEraseing)
        {
            eraserCollider.enabled = isEraseing;
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other && other.transform.parent)
            {
                Line line = other.transform.parent.GetComponent<Line>();
                if (line)
                {
                    unyStylusController.linePool.SendCustomNetworkEvent(
                        VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                        nameof(LinePool.RemoveLine),
                        line.playerId,
                        line.lineId
                    );
                }
            }
        }


        public void OnSizeChanged()
        {
            transform.localScale = Vector3.one * (widthSliderMenu.SyncedEraserWidth / transform.parent.lossyScale.x);
        }
    }
}
