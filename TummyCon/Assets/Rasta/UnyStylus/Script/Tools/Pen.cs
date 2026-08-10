
using System;
using UdonSharp;
using UnityEngine;
using VRC.SDK3.Data;
using VRC.SDK3.UdonNetworkCalling;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    public class Pen : UdonSharpBehaviour
    {
        [SerializeField] private UnyStylus unyStylus;
        [SerializeField] private UnyStylusController unyStylusController;
        [SerializeField] private PenMenu penMenu;
        [SerializeField] private Menu_ColorWheel colorWheelMenu;
        [SerializeField] private Menu_WidthSlider widthSliderMenu;
        [SerializeField] private Transform penTipTransform;
        [SerializeField] private LineRenderer tmpLine;
        [SerializeField] private Menu_PenMode penModeMenu;
        [SerializeField] private Collider[] ignoreColliders;
        [SerializeField] private LineRenderer dottedLineRenderer;

        private LinePool unyStylusPool;
        private int targetLineId = -1;
        private Color targetLineColor = Color.white;
        private float targetLineWidth = 0.0f;
        private byte targetLineLayerId = 0;
        private bool isDrawing = false;

        private Vector3 drawPos = Vector3.zero;

        void Start()
        {
            unyStylusPool = unyStylusController.linePool;
        }

        public void SetLineMaterial(Material pc, Material mobile)
        {
#if UNITY_STANDALONE
            tmpLine.material = pc;
#else
            tmpLine.material = mobile;
#endif
        }

        public void OnChangedPenMode()
        {
            int penMode = penModeMenu.SyncedPenMode;

            if (isDrawing && penMode != (int)UnyStylusMode.Draw)
            {
                Draw(false);
            }
        }

        public void OnUnyStylusPickupUseDown()
        {
            if (penModeMenu.SyncedPenMode != (int)UnyStylusMode.Draw) return;
            if (!Networking.LocalPlayer.IsUserInVR() && penMenu.IsRaycastMenu()) return;

            SendCustomNetworkEvent(
                VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                nameof(Draw),
                true
            );
        }

        public void OnUnyStylusPickupUseUp()
        {
            if (penModeMenu.SyncedPenMode != (int)UnyStylusMode.Draw) return;
            if (!Networking.LocalPlayer.IsUserInVR() && (!isDrawing && penMenu.IsRaycastMenu())) return;

            SendCustomNetworkEvent(
                VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                nameof(Draw),
                false
            );
        }

        public void OnUnyStylusDrop()
        {
            if (penModeMenu.SyncedPenMode != (int)UnyStylusMode.Draw) return;

            SendCustomNetworkEvent(
                VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                nameof(Drop)
            );
        }

        public void Drop()
        {
            if (isDrawing)
            {
                Draw(false);
            }
        }

        [NetworkCallable]
        public void Draw(bool isDrawing)
        {
            this.isDrawing = isDrawing;

            if (isDrawing)
            {
                tmpLine.positionCount = 1;
                tmpLine.SetPosition(0, drawPos);
                tmpLine.startColor = colorWheelMenu.SyncedLineColor;
                tmpLine.endColor = colorWheelMenu.SyncedLineColor;

#if UNITY_STANDALONE
                tmpLine.material.SetFloat("_Width", widthSliderMenu.SyncedLineWidth);
#else
                tmpLine.widthMultiplier = widthSliderMenu.SyncedLineWidth;
                tmpLine.numCapVertices = 10;
#endif
                
                targetLineId = -1;
                targetLineColor = colorWheelMenu.SyncedLineColor;
                targetLineWidth = widthSliderMenu.SyncedLineWidth;
                targetLineLayerId = penModeMenu.SyncedLayerId;
            }
            else
            {
                if (Networking.IsOwner(gameObject))
                {
                    if (targetLineId == -1)
                    {
                        targetLineId = unyStylusPool.GetLastLineId(Networking.LocalPlayer.playerId) + 1;
                    }
                    SyncLine(targetLineId, targetLineColor, targetLineWidth, targetLineLayerId);
                }
                tmpLine.positionCount = 0;
            }
        }

        void Update()
        {
            drawPos = penTipTransform.position;
            if (penModeMenu.SyncedIsOnSurface && penModeMenu.SyncedPenMode == (int)UnyStylusMode.Draw)
            {
                Collider[] overlapCols = Physics.OverlapSphere(penTipTransform.position, 0.5f, unyStylus.drawSurfaceLayerMask, QueryTriggerInteraction.Ignore); // Ignore Pickup & Player(Line Collider)
                float closestDistance = float.MaxValue;
                foreach (Collider col in overlapCols)
                {
                    if (col)
                    {
                        if (Array.IndexOf(ignoreColliders, col) >= 0)
                        {
                            continue;
                        }
                        Vector3 point = col.ClosestPoint(penTipTransform.position);
                        if (point == penTipTransform.position)
                        {
                            continue;
                        }
                        float dist = Vector3.Distance(point, penTipTransform.position);
                        if (dist < closestDistance)
                        {
                            closestDistance = dist;
                            drawPos = (penTipTransform.position - point).normalized * widthSliderMenu.SyncedLineWidth * 0.5f + point;
                        }
                    }
                }

                dottedLineRenderer.gameObject.SetActive(true);
                dottedLineRenderer.SetPosition(0, penTipTransform.position);
                dottedLineRenderer.SetPosition(1, drawPos);
            }
            else
            {
                dottedLineRenderer.gameObject.SetActive(false);
            }


            if (isDrawing)
            {
                if (penModeMenu.SyncedDrawMode == 0)
                {
                    if (Vector3.Distance(tmpLine.GetPosition(tmpLine.positionCount - 1), drawPos) > 0.001f)
                    {
                        drawPos = Vector3.Lerp(
                            tmpLine.GetPosition(tmpLine.positionCount - 1),
                            drawPos,
                            0.4f
                        );

                        tmpLine.positionCount += 1;
                        tmpLine.SetPosition(tmpLine.positionCount - 1, drawPos);
                    }

                    if (Networking.IsOwner(gameObject))
                    {
                        Vector3[] p = new Vector3[tmpLine.positionCount];
                        tmpLine.GetPositions(p);
                        tmpLine.Simplify(0.0005f);

                        if (tmpLine.positionCount >= unyStylusPool.maxChunkSize)
                        {
                            SendCustomNetworkEvent(
                                VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                                nameof(CutLine)
                            );
                        }
                        else
                        {
                            tmpLine.positionCount = p.Length;
                            tmpLine.SetPositions(p);
                        }
                    }
                }
                else if (penModeMenu.SyncedDrawMode == 1)
                {
                    if (Vector3.Distance(tmpLine.GetPosition(0), drawPos) > 0.001f)
                    {
                        tmpLine.positionCount = 2;
                        tmpLine.SetPosition(1, drawPos);
                    }
                }
            }
        }

        [NetworkCallable]
        public void CutLine()
        {
            if (Networking.IsOwner(gameObject))
            {
                if (targetLineId == -1)
                {
                    targetLineId = unyStylusPool.GetLastLineId(Networking.LocalPlayer.playerId) + 1;
                }
                SyncLine(targetLineId, targetLineColor, targetLineWidth, targetLineLayerId);
            }

            tmpLine.positionCount = 1;
            tmpLine.SetPosition(0, drawPos);
        }

        private void SyncLine(int lineId, Color lineColor, float lineWidth, byte layerId)
        {
            if (lineId < 0) return;

            tmpLine.Simplify(0.0005f);
            if (tmpLine.positionCount != 0)
            {
                Vector3[] positions = new Vector3[tmpLine.positionCount];
                tmpLine.GetPositions(positions);
                int playerId = Networking.LocalPlayer.playerId;

                DataDictionary linePool = unyStylusPool.GetLinePool();

                int targetChunkId = 0;
                if (linePool.ContainsKey(playerId))
                {
                    DataDictionary playerDict = linePool[playerId].DataDictionary;
                    if (playerDict.ContainsKey(lineId))
                    {
                        DataDictionary lineData = playerDict[lineId].DataDictionary;
                        DataDictionary chunks = lineData["chunks"].DataDictionary;
                        DataList chunkKeys = chunks.GetKeys();
                        for (int i = 0; i < chunkKeys.Count; i++)
                        {
                            if (chunkKeys[i].Int >= targetChunkId)
                            {
                                targetChunkId = chunkKeys[i].Int + 1;
                            }
                        }
                    }
                }
                SendCustomNetworkEvent(
                    VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                    nameof(SetLine),
                    playerId,
                    lineId,
                    targetChunkId,
                    lineColor,
                    lineWidth,
                    layerId,
                    positions
                );
            }
        }

        [NetworkCallable]
        public void SetLine(int playerId, int lineId, int chunkId, Color lineColor, float lineWidth, byte layerId, Vector3[] positions)
        {
            unyStylusPool.SetLine(playerId, lineId, chunkId, lineColor, lineWidth, layerId, positions);
        }
    }
}
