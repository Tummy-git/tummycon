
using UdonSharp;
using UnityEngine;
using VRC.SDK3.Rendering;
using VRC.SDKBase;
using VRC.Udon;
using VRC.Udon.Common.Interfaces;

namespace Rasta.UnyStylus
{
    public class ColorPicker : UdonSharpBehaviour
    {
        [SerializeField] private Menu_PenMode penModeMenu;
        [SerializeField] private Collider menuCollider;
        [SerializeField] private Menu_ColorWheel colorWheelMenu;
        [SerializeField] private Camera colorPickCamera;
        [SerializeField] private GameObject pickTarget;

        private Color lastPickedColor = Color.white;
        private Color beforeColor = Color.white;

        private int beforePenMode = -1;

        public void OnChangedPenMode()
        {
            bool isColorPickMode = penModeMenu.SyncedPenMode == (int)UnyStylusMode.ColorPick;
            colorPickCamera.enabled = isColorPickMode;
            pickTarget.SetActive(isColorPickMode);

            if (Networking.IsOwner(gameObject))
            {
                if (isColorPickMode)
                {
                    beforeColor = colorWheelMenu.SyncedLineColor;
                }
                else if (beforePenMode == (int)UnyStylusMode.ColorPick)
                {
                    colorWheelMenu.SyncedLineColor = beforeColor;
                }
            }

            beforePenMode = penModeMenu.SyncedPenMode;
        }

        public void OnUnyStylusPickupUseDown()
        {
            if (penModeMenu.SyncedPenMode != (int)UnyStylusMode.ColorPick) return;
            if (!Networking.LocalPlayer.IsUserInVR() && IsRaycastMenu()) return;

            if (Networking.IsOwner(gameObject))
            {
                colorWheelMenu.SyncedLineColor = lastPickedColor;
                beforeColor = lastPickedColor;

                penModeMenu.SyncedPenMode = (int)UnyStylusMode.Draw;
            }
        }

        private bool IsRaycastMenu()
        {
            VRCPlayerApi.TrackingData headData = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.Head);
            Physics.Raycast(headData.position, headData.rotation * Vector3.forward, out RaycastHit hitInfo, 5.0f);
            return hitInfo.collider == menuCollider;
        }

        void OnPostRender()
        {
            VRCAsyncGPUReadback.Request(colorPickCamera.targetTexture, 0, (IUdonEventReceiver)this);
        }

        public override void OnAsyncGpuReadbackComplete(VRCAsyncGPUReadbackRequest request)
        {
            if (request.hasError)
            {
                return;
            }
            else
            {
                Color32[] px = new Color32[1];
                request.TryGetData(px);

                Color pickedColor = ((Color)px[0]).gamma;
                colorWheelMenu.SetRGB(pickedColor);
                lastPickedColor = pickedColor;
            }
        }
    }
}
