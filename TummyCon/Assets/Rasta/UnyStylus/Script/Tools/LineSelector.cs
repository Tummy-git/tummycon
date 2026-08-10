
using System;
using UdonSharp;
using UnityEngine;
using VRC.SDK3.Data;
using VRC.SDK3.UdonNetworkCalling;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
    public class LineSelector : UdonSharpBehaviour
    {
        [SerializeField] private UnyStylusController controller;
        [SerializeField] private PenMenu penMenu;
        [SerializeField] private Transform penTip;
        [SerializeField] private GameObject selectObject;
        [SerializeField] private Transform selectCube;
        [SerializeField] private Transform selectCubeScaler;
        [SerializeField] private LineRenderer[] selectCubeLines;
        [SerializeField] private Transform selectedLinesParent;
        [SerializeField] private Menu_PenMode penModeMenu;
        [SerializeField] private Material selectedLineMaterial;
        [SerializeField] private Transform loadingCube;
        [SerializeField] private GameObject cancelMove;

        private bool isSelecting = false;
        private bool isMoving = false;

        private DataList selectedLines = new DataList();
        private DataDictionary beforeLinePool = new DataDictionary();
        private DataDictionary emptyDataDict = new DataDictionary();

        private int syncMode = 0;
        private DataList syncQueue = new DataList();
        private int totalQueueCount = 0;
        [UdonSynced] private bool syncedIsSyncing = false;
        private bool isCancelSyncing = false;

        void Start()
        {
            selectCube.SetParent(null, true);
            selectCubeScaler.localScale = Vector3.zero;
        }

        public void OnChangedPenMode()
        {
            int penMode = penModeMenu.SyncedPenMode;
            
            selectObject.SetActive(penMode == (int)UnyStylusMode.Select);

            if (penMode != (int)UnyStylusMode.Select && !syncedIsSyncing)
            {
                ClearSelection();
                isSelecting = false;
                isMoving = false;
                selectCubeScaler.localScale = Vector3.zero;
                selectCube.gameObject.SetActive(false);
            }
            else
            {
                selectCube.gameObject.SetActive(true);
            }
        }

        public void OnUnyStylusPickupUseDown()
        {
            if (penModeMenu.SyncedPenMode != (int)UnyStylusMode.Select) return;
            if (!Networking.LocalPlayer.IsUserInVR() && penMenu.IsRaycastMenu()) return;
            Select(true);
        }

        public void OnUnyStylusPickupUseUp()
        {
            if (penModeMenu.SyncedPenMode != (int)UnyStylusMode.Select) return;
            if (!Networking.LocalPlayer.IsUserInVR() && !isSelecting && penMenu.IsRaycastMenu()) return;
            Select(false);
        }

        public void OnUnyStylusDrop()
        {
            if (penModeMenu.SyncedPenMode != (int)UnyStylusMode.Select) return;
            if (isSelecting)
            {
                Select(false);
            }
        }

        // Owner Only
        public void Select(bool isSelecting)
        {
            if (syncedIsSyncing) return;

            if (isSelecting)
            {
                bool isPenTipInside = false;
                if (selectCubeScaler.localScale != Vector3.zero)
                {
                    Vector3 localPenTipPos = selectCubeScaler.InverseTransformPoint(penTip.position);
                    if (
                        localPenTipPos.x >= 0 && localPenTipPos.x <= 1 &&
                        localPenTipPos.y >= 0 && localPenTipPos.y <= 1 &&
                        localPenTipPos.z >= 0 && localPenTipPos.z <= 1
                    )
                    {
                        isPenTipInside = true;
                    }
                }

                if (!isPenTipInside)
                {
                    selectCube.position = penTip.position;
                    Vector3 headDirection = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.Head).rotation * Vector3.forward;
                    selectCube.LookAt(selectCube.position + new Vector3(headDirection.x, 0, headDirection.z));
                    SendCustomNetworkEvent(
                        VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                        nameof(StartSelect),
                        selectCube.position,
                        selectCube.rotation
                    );
                }
                else
                {
                    if (isSelectLoopRunning) return;

                    selectCube.SetParent(penTip, true);
                    SendCustomNetworkEvent(
                        VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                        nameof(StartMove),
                        selectCube.localPosition,
                        selectCube.localRotation,
                        selectCubeScaler.localScale
                    );
                }
            }
            else
            {
                if (isSelectLoopRunning) return;

                if (!isMoving)
                {
                    Vector3 scale = selectCubeScaler.localScale;
                    Vector3 pos = Vector3.zero;
                    if (scale.x < 0) pos.x = 1;
                    if (scale.y < 0) pos.y = 1;
                    if (scale.z < 0) pos.z = 1;
                    scale.x = Mathf.Abs(scale.x);
                    scale.y = Mathf.Abs(scale.y);
                    scale.z = Mathf.Abs(scale.z);
                    pos = selectCubeScaler.TransformPoint(pos);

                    SendCustomNetworkEvent(
                        VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                        nameof(EndSelect),
                        pos,
                        selectCube.rotation,
                        scale
                    );
                }
                else
                {
                    SendCustomNetworkEvent(
                        VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                        nameof(EndMove),
                        selectCube.position,
                        selectCube.rotation,
                        selectCubeScaler.localScale
                    );
                }
            }
        }

        void Update()
        {
            if (isSelecting)
            {
                Vector3 scale = selectCube.InverseTransformPoint(penTip.position);
                selectCubeScaler.localScale = scale;
            }
        }

        [NetworkCallable]
        public void StartSelect(Vector3 selectCubePos, Quaternion selectCubeRot)
        {
            isSelecting = true;
            isMoving = false;
            selectCube.SetParent(null, true);
            selectCube.position = selectCubePos;
            selectCube.rotation = selectCubeRot;
            selectCubeScaler.localScale = Vector3.zero;

            isSelectLoopRunning = false;
            ClearSelection();
        }

        [NetworkCallable]
        public void EndSelect(Vector3 selectCubePos, Quaternion selectCubeRot, Vector3 selectCubeScale)
        {
            isSelecting = false;
            isMoving = false;
            selectCube.SetParent(null, true);
            selectCube.position = selectCubePos;
            selectCube.rotation = selectCubeRot;
            selectCubeScaler.localScale = selectCubeScale;
            
            ClearSelection();

            Vector3 size = selectCubeScale;
            size.x = Mathf.Abs(size.x);
            size.y = Mathf.Abs(size.y);
            size.z = Mathf.Abs(size.z);
            overlapCols = Physics.OverlapBox(
                selectCubeScaler.TransformPoint(new Vector3(0.5f, 0.5f, 0.5f)),
                size / 2,
                selectCube.rotation,
                1 << 9 // Layer 9: Player
            );
            
            selectedLines.Clear();
            targetIndex = 0;
            if (isSelectLoopRunning)
            {
                isSelectLoopRunning = false;
                SendCustomEventDelayedFrames(
                    nameof(StartSelectLoop),
                    1
                );
            }
            else
            {
                StartSelectLoop();
            }

            beforeLinePool = controller.linePool.GetLinePool().DeepClone();
        }

        public void StartSelectLoop()
        {
            isSelectLoopRunning = true;
            SelectLoop();
        }

        private bool isSelectLoopRunning = false;
        private Collider[] overlapCols = new Collider[0];
        private int targetIndex = 0;
        public void SelectLoop()
        {
            for (int i = 0; i < 10; i++)
            {
                if (!isSelectLoopRunning)
                {
                    ClearSelection();
                    selectedLines.Clear();
                    return;
                }

                if (targetIndex >= overlapCols.Length)
                {
                    isSelectLoopRunning = false;
                    if (selectedLines.Count == 0)
                    {
                        selectCubeScaler.localScale = Vector3.zero;
                    }
                    return;
                }

                Collider col = overlapCols[targetIndex];
                if (col == null || col.transform.parent == null) 
                {
                    targetIndex++;
                    continue;
                }
                Line line = col.transform.parent.GetComponent<Line>();
                if (line)
                {
                    GameObject lineGameObject = Instantiate(line.gameObject);
                    Destroy(lineGameObject.transform.GetChild(0).gameObject);
                    LineRenderer lineRenderer = lineGameObject.GetComponent<LineRenderer>();
#if UNITY_STANDALONE
                    lineRenderer.material = controller.linePool.inkPcSelected;
                    lineRenderer.material.SetFloat("_Width", line.width);
#else
                    lineRenderer.material = controller.linePool.inkMobileSelected;
#endif
                    lineGameObject.transform.SetParent(selectedLinesParent, true);
                    int playerId = line.playerId;
                    int lineId = line.lineId;
                    string lineKey = $"{playerId}_{lineId}";
                    if (!selectedLines.Contains(lineKey))
                    {
                        selectedLines.Add(lineKey);
                    }
                }

                targetIndex++;
            }

            SendCustomEventDelayedFrames(
                nameof(SelectLoop),
                1
            );
        }

        [NetworkCallable]
        public void StartMove(Vector3 selectCubeLocalPos, Quaternion selectCubeLocalRot, Vector3 selectCubeScale)
        {
            isSelecting = false;
            isMoving = true;

            selectCube.SetParent(penTip, true);
            selectCube.localPosition = selectCubeLocalPos;
            selectCube.localRotation = selectCubeLocalRot;
            selectCubeScaler.localScale = selectCubeScale;
            selectedLinesParent.gameObject.SetActive(true);
        }

        [NetworkCallable]
        public void EndMove(Vector3 selectCubePos, Quaternion selectCubeRot, Vector3 selectCubeScale)
        {
            isSelecting = false;
            isMoving = false;
            selectCube.SetParent(null, true);
            selectCube.position = selectCubePos;
            selectCube.rotation = selectCubeRot;
            selectCubeScaler.localScale = selectCubeScale;

            if (Networking.IsOwner(gameObject))
            {
                int lineCount = selectedLinesParent.childCount;
                if (lineCount != 0)
                {
                    syncMode = penModeMenu.SyncedSelectMode;
                    for (int i = 0; i < selectedLines.Count; i++)
                    {
                        string[] lineInfo = selectedLines[i].String.Split('_');
                        // int playerId = selectedLines[i].DataList[0].Int;
                        // int lineId = selectedLines[i].DataList[1].Int;
                        int playerId = int.Parse(lineInfo[0]);
                        int lineId = int.Parse(lineInfo[1]);
                        
                        if (!beforeLinePool.ContainsKey(playerId)) continue;
                        if (!beforeLinePool[playerId].DataDictionary.ContainsKey(lineId)) continue;
                        DataDictionary lineDict = beforeLinePool[playerId].DataDictionary[lineId].DataDictionary;
                        DataDictionary chunks = lineDict["chunks"].DataDictionary;
                        DataList chunkKeys = chunks.GetKeys();
                        chunkKeys.Sort();
                        for (int j = 0; j < chunkKeys.Count; j++)
                        {
                            int chunkId = chunkKeys[j].Int;

                            DataDictionary syncQueueData = emptyDataDict.DeepClone();
                            syncQueueData["playerId"] = playerId;
                            syncQueueData["lineId"] = lineId;
                            syncQueueData["chunkId"] = chunkId;
                            syncQueue.Add(syncQueueData);
                        }
                    }

                    totalQueueCount = syncQueue.Count;
                    isCancelSyncing = false;
                    SendCustomNetworkEvent(
                        VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                        nameof(ShowCancelSyncing)
                    );
                    SyncData();
                }
            }
        }

        [NetworkCallable]
        public void ShowCancelSyncing()
        {
            cancelMove.SetActive(true);
        }

        [NetworkCallable]
        public void CancelSyncing()
        {
            if (Networking.IsOwner(gameObject))
            {
                isCancelSyncing = true;
            }
            cancelMove.SetActive(false);
        }

        public void SyncData()
        {
            syncedIsSyncing = true;
            RequestSerialization();

            if (Networking.IsClogged)
            {
                SendCustomEventDelayedSeconds(
                    nameof(SyncData),
                    3.0f
                );
                return;
            }

            int totalPositions = 0;

            while(syncQueue.Count > 0 && totalPositions < controller.linePool.maxChunkSize)
            // while(syncQueue.Count > 0 && (totalPositions < controller.linePool.maxChunkSize))
            {
                DataDictionary data = syncQueue[0].DataDictionary;
                int playerId = data["playerId"].Int;
                int lineId = data["lineId"].Int;
                int chunkId = data["chunkId"].Int;
                syncQueue.RemoveAt(0);

                if (isCancelSyncing && chunkId == 0)
                {
                    syncQueue.Clear();
                    break;
                }

                if (selectedLinesParent.childCount == 0)
                {
                    continue;
                }
                Transform moveTransform = selectedLinesParent.GetChild(0);
                if (beforeLinePool.ContainsKey(playerId))
                {
                    DataDictionary playerDict = beforeLinePool[playerId].DataDictionary;
                    if (playerDict.ContainsKey(lineId))
                    {
                        DataDictionary lineData = playerDict[lineId].DataDictionary;
                        DataDictionary chunks = lineData["chunks"].DataDictionary;
                        if (chunks.ContainsKey(chunkId))
                        {
                            DataDictionary chunkData = chunks[chunkId].DataDictionary;
                            DataList positionsDataList = chunkData["positions"].DataList;
                            Vector3[] positions = LinePool.Vector3ArrayFromDataList(positionsDataList);

                            for (int i = 0; i < positions.Length; i++)
                            {
                                positions[i] = moveTransform.TransformPoint(positions[i]);
                            }

                            totalPositions += positions.Length;

                            if (syncMode == 0)
                            {
                                // Move
                                controller.linePool.SendCustomNetworkEvent(
                                    VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                                    nameof(LinePool.SetLine),
                                    playerId,
                                    lineId,
                                    chunkId,
                                    LinePool.FromHtmlStringRGBA(lineData["lineColor"].String),
                                    lineData["lineWidth"].Float,
                                    lineData["layerId"].Byte,
                                    positions
                                );
                            }
                            else if (syncMode == 1)
                            {
                                // Duplicate
                                controller.linePool.SendCustomNetworkEvent(
                                    VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                                    nameof(LinePool.SetLine),
                                    Networking.LocalPlayer.playerId,
                                    controller.linePool.GetLastLineId(Networking.LocalPlayer.playerId) + (chunkId == 0 ? 1 : 0),
                                    chunkId,
                                    LinePool.FromHtmlStringRGBA(lineData["lineColor"].String),
                                    lineData["lineWidth"].Float,
                                    lineData["layerId"].Byte,
                                    positions
                                );
                            }
                        }
                    }
                }
            }

            if (syncQueue.Count == 0)
            {
                syncedIsSyncing = false;
                RequestSerialization();
                SendCustomNetworkEvent(
                    VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                    nameof(SetLoadingCube),
                    -1f
                );
                if (isCancelSyncing)
                {
                    SendCustomNetworkEvent(
                        VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                        nameof(ForceCancelSelecting)
                    );
                }
            }
            else
            {
                SendCustomNetworkEvent(
                    VRC.Udon.Common.Interfaces.NetworkEventTarget.All,
                    nameof(SetLoadingCube),
                    (float)(totalQueueCount - syncQueue.Count) / totalQueueCount
                );

                if (VRCPlayerApi.GetPlayerCount() == 1)
                {
                    SendCustomEventDelayedFrames(
                        nameof(SyncData),
                        1
                    );
                }
                else
                {
                    SendCustomEventDelayedSeconds(
                        nameof(SyncData),
                        1.0f
                    );
                }
            }
        }

        [NetworkCallable]
        public void SetLoadingCube(float scaleY)
        {
            if (scaleY < 0f)
            {
                loadingCube.localScale = Vector3.zero;
                cancelMove.SetActive(false);
                
                if (penModeMenu.SyncedPenMode != (int)UnyStylusMode.Select)
                {
                    ClearSelection();
                    isSelecting = false;
                    isMoving = false;
                    selectCubeScaler.localScale = Vector3.zero;
                }
                return;
            }

            Vector3 scale = Vector3.one;
            scale.y = scaleY;
            loadingCube.localScale = scale;
        }

        public void ForceCancelSelecting()
        {
            selectCubeScaler.localScale = Vector3.zero;
            ClearSelection();
        }

        public DataList GetSelectedLines()
        {
            return selectedLines;
        }






        private void ClearSelection()
        {
            while (selectedLinesParent.childCount > 0)
            {
                DestroyImmediate(selectedLinesParent.GetChild(0).gameObject);
            }
        }

        public void OnSyncedSelectModeChanged()
        {
            int mode = penModeMenu.SyncedSelectMode;

            if (mode == 0)
            {
                SetSelectCubeLineColors(Color.white);
            }
            else if (mode == 1)
            {
                SetSelectCubeLineColors(Color.green);
            }
        }

        private void SetSelectCubeLineColors(Color color)
        {
            foreach (var line in selectCubeLines)
            {
                line.startColor = color;
                line.endColor = color;
            }
        }
    }
}
