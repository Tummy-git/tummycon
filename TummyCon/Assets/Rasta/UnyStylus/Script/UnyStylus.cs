
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    public class UnyStylus : UdonSharpBehaviour
    {
        [Header("エクスポート機能")]
        [SerializeField] private bool isEnableExport = true;
        [Header("呼び出し機能")]
        public bool isEnableQuickCall = true;
        [Header("デフォルトの線の太さ"), Range(0, 10)]
        public int defaultLineWidth = 4;
        [Header("デフォルトの消しゴムの太さ"), Range(0, 10)]
        public int defaultEraserWidth = 6;
        [Header("壁コライダーのレイヤー")]
        public LayerMask drawSurfaceLayerMask;
        [Header("デフォルト色")]
        public Color[] playerColors;
        [Space(40)]

        [SerializeField] private GameObject exportNotAllowedObject;
        [SerializeField] private UdonBehaviour[] pickupCallbacks;

        void Start()
        {
            exportNotAllowedObject.SetActive(!isEnableExport);
        }

        public override void OnPickup()
        {
            foreach (UdonBehaviour callback in pickupCallbacks)
            {
                callback.SendCustomEvent("OnUnyStylusPickup");
            }
        }

        public override void OnPickupUseDown()
        {
            foreach (UdonBehaviour callback in pickupCallbacks)
            {
                callback.SendCustomEvent("OnUnyStylusPickupUseDown");
            }
        }

        public override void OnPickupUseUp()
        {
            foreach (UdonBehaviour callback in pickupCallbacks)
            {
                callback.SendCustomEvent("OnUnyStylusPickupUseUp");
            }
        }

        public override void OnDrop()
        {
            foreach (UdonBehaviour callback in pickupCallbacks)
            {
                callback.SendCustomEvent("OnUnyStylusDrop");
            }
        }
    }
}
