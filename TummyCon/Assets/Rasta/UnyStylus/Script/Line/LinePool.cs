
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDK3.Data;
using VRC.SDK3.UdonNetworkCalling;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
    public class LinePool : UdonSharpBehaviour
    {
        public GameObject linePrefab;

        [HideInInspector] public Material inkPc;
        [HideInInspector] public Material inkMobile;
        [HideInInspector] public Material inkPcSelected;
        [HideInInspector] public Material inkMobileSelected;

        private DataDictionary linePool = new DataDictionary();
        private DataDictionary linePoolDataId = new DataDictionary();
        private DataList dataIdList = new DataList();
        private DataDictionary lineRenderers = new DataDictionary();

        private DataDictionary emptyDataDict = new DataDictionary();
        private ulong dataIdCounter = 0;
        private ulong lateJoinerSyncLastDataId = 0;
        private int lateJoinerDataIdListIndex = 0;
        private bool syncAllOneMore = false;
        private ulong oneMoreLastDataId = 0;

        [UdonSynced, FieldChangeCallback(nameof(SyncedHasLateJoiner))] private bool syncedHasLateJoiner;

        [HideInInspector] public int maxChunkSize = 100;

        [NetworkCallable]
        public void SetLine(
            int playerId,
            int lineId,
            int chunkId,
            Color lineColor,
            float lineWidth,
            byte layerId,
            Vector3[] positions
        )
        {
            // linePool
            if (!linePool.ContainsKey(playerId))
            {
                linePool[playerId] = emptyDataDict.DeepClone();
            }
            DataDictionary playerDict = linePool[playerId].DataDictionary;
            bool isNewLine = !playerDict.ContainsKey(lineId);
            DataDictionary lineData = isNewLine ? emptyDataDict.DeepClone() : playerDict[lineId].DataDictionary;

            lineData["lineColor"] = ToHtmlStringRGBA(lineColor);
            lineData["lineWidth"] = lineWidth;
            lineData["layerId"] = layerId;
            DataDictionary chunks = isNewLine ? emptyDataDict.DeepClone() : lineData["chunks"].DataDictionary;
            bool isNewChunk = !chunks.ContainsKey(chunkId);
            DataDictionary chunkData = isNewChunk ? emptyDataDict.DeepClone() : chunks[chunkId].DataDictionary;
            chunkData["dataId"] = isNewChunk ? ++dataIdCounter : chunkData["dataId"];
            chunkData["positions"] = DataListFromVector3Array(positions);
            chunks[chunkId] = chunkData;
            lineData["chunks"] = chunks;
            
            playerDict[lineId] = lineData;
            linePool[playerId] = playerDict;

            // dataIdList and linePoolDataId
            if (isNewChunk)
            {
                dataIdList.Add(dataIdCounter);
                DataDictionary dataIdData = emptyDataDict.DeepClone();
                dataIdData["playerId"] = playerId;
                dataIdData["lineId"] = lineId;
                dataIdData["chunkId"] = chunkId;
                linePoolDataId[dataIdCounter] = dataIdData;
            }

            // Set Line
            string lineRendererKey = $"{playerId}_{lineId}";
            if (!lineRenderers.ContainsKey(lineRendererKey))
            {
                Line newUnyStylusLine = Instantiate(
                    linePrefab,
                    transform
                ).GetComponent<Line>();
                newUnyStylusLine.Init(playerId, lineId, lineColor, lineWidth, inkPc, inkMobile, inkPcSelected, inkMobileSelected);
                lineRenderers[lineRendererKey] = newUnyStylusLine;
            }

            Line unyStylusLine = (Line)lineRenderers[lineRendererKey].Reference;
            unyStylusLine.SetLine(chunkId, positions);
        }

        [NetworkCallable]
        public void RemoveLine(int playerId, int lineId)
        {
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
                        int chunkId = chunkKeys[i].Int;
                        DataDictionary chunkData = chunks[chunkId].DataDictionary;
                        ulong dataId = chunkData["dataId"].ULong;
                        linePoolDataId.Remove(dataId);
                        dataIdList.Remove(dataId);
                    }
                    playerDict.Remove(lineId);
                    linePool[playerId] = playerDict;
                }
            }
            string lineRendererKey = $"{playerId}_{lineId}";
            if (lineRenderers.ContainsKey(lineRendererKey))
            {
                Line unyStylusLine = (Line)lineRenderers[lineRendererKey].Reference;
                Destroy(unyStylusLine.gameObject);
                lineRenderers.Remove(lineRendererKey);
            }
        }

        [NetworkCallable]
        public void RemoveSelfLines(int playerId, byte layerId)
        {
            if (linePool.ContainsKey(playerId))
            {
                DataDictionary playerDict = linePool[playerId].DataDictionary;
                DataList lineIds = playerDict.GetKeys().DeepClone();
                for (int i = 0; i < lineIds.Count; i++)
                {
                    if (playerDict[lineIds[i].Int].DataDictionary["layerId"].Byte == layerId)
                    {
                        RemoveLine(playerId, lineIds[i].Int);
                    }
                }
            }
        }

        [NetworkCallable]
        public void RemoveAllLines()
        {
            linePool.Clear();
            linePoolDataId.Clear();
            dataIdList.Clear();
            lineRenderers.Clear();
            foreach (Transform child in transform)
            {
                Destroy(child.gameObject);
            }
        }

        public static string ToHtmlStringRGBA(Color color)
        {
            int r = Mathf.Clamp(Mathf.RoundToInt(color.r * 255f), 0, 255);
            int g = Mathf.Clamp(Mathf.RoundToInt(color.g * 255f), 0, 255);
            int b = Mathf.Clamp(Mathf.RoundToInt(color.b * 255f), 0, 255);
            int a = Mathf.Clamp(Mathf.RoundToInt(color.a * 255f), 0, 255);
            return $"{r:X2}{g:X2}{b:X2}{a:X2}";
        }

        public static Color FromHtmlStringRGBA(string htmlString)
        {
            if (htmlString.Length != 8) return Color.white;
            byte r = byte.Parse(htmlString.Substring(0, 2), System.Globalization.NumberStyles.HexNumber);
            byte g = byte.Parse(htmlString.Substring(2, 2), System.Globalization.NumberStyles.HexNumber);
            byte b = byte.Parse(htmlString.Substring(4, 2), System.Globalization.NumberStyles.HexNumber);
            byte a = byte.Parse(htmlString.Substring(6, 2), System.Globalization.NumberStyles.HexNumber);
            return new Color32(r, g, b, a);
        }

        public static DataList DataListFromVector3Array(Vector3[] positions)
        {
            DataList positionsDataList = new DataList();
            foreach (Vector3 pos in positions)
            {
                DataList posList = new DataList(new DataToken[] {
                    pos.x,
                    pos.y,
                    pos.z
                });
                positionsDataList.Add(posList);
            }
            return positionsDataList;
        }

        public static Vector3[] Vector3ArrayFromDataList(DataList dataList)
        {
            Vector3[] positions = new Vector3[dataList.Count];
            for (int i = 0; i < dataList.Count; i++)
            {
                DataList posList = dataList[i].DataList;
                positions[i] = new Vector3(
                    posList[0].Float,
                    posList[1].Float,
                    posList[2].Float
                );
            }
            return positions;
        }

        public int GetLastLineId(int playerId)
        {
            if (linePool.ContainsKey(playerId))
            {
                DataList keys = linePool[playerId].DataDictionary.GetKeys();
                int maxId = -1;
                for (int i = 0; i < keys.Count; i++)
                {
                    if (keys[i].Int > maxId)
                    {
                        maxId = keys[i].Int;
                    }
                }
                return maxId;
            }
            return -1;
        }

        public string GetLineColorString(int playerId, int lineId)
        {
            if (linePool.ContainsKey(playerId))
            {
                DataDictionary playerDict = linePool[playerId].DataDictionary;
                if (playerDict.ContainsKey(lineId))
                {
                    DataDictionary lineData = playerDict[lineId].DataDictionary;
                    return lineData["lineColor"].String;
                }
            }
            return "FFFFFFFF";
        }

        public Color GetLineColor(int playerId, int lineId)
        {
            if (linePool.ContainsKey(playerId))
            {
                DataDictionary playerDict = linePool[playerId].DataDictionary;
                if (playerDict.ContainsKey(lineId))
                {
                    DataDictionary lineData = playerDict[lineId].DataDictionary;
                    return FromHtmlStringRGBA(lineData["lineColor"].String);
                }
            }
            return Color.white;
        }

        public float GetLineWidth(int playerId, int lineId)
        {
            if (linePool.ContainsKey(playerId))
            {
                DataDictionary playerDict = linePool[playerId].DataDictionary;
                if (playerDict.ContainsKey(lineId))
                {
                    DataDictionary lineData = playerDict[lineId].DataDictionary;
                    return lineData["lineWidth"].Float;
                }
            }
            return 0.0f;
        }

        public DataDictionary GetLinePool()
        {
            return linePool;
        }

        // LateJoiner
        public override void OnPlayerJoined(VRCPlayerApi player)
        {
            if (player.isLocal) return;
            
            lateJoinerSyncLastDataId = dataIdCounter;
            if (Networking.IsOwner(gameObject))
            {
                if (!SyncedHasLateJoiner)
                {
                    SyncedHasLateJoiner = true;
                    syncAllOneMore = false;
                    lateJoinerDataIdListIndex = 0;
                    SendLateJoinerData();
                }
                else
                {
                    oneMoreLastDataId = dataIdList[lateJoinerDataIdListIndex].ULong;
                    syncAllOneMore = true;
                }
            }
        }

        public override void OnPlayerLeft(VRCPlayerApi player)
        {
            if (Networking.IsOwner(gameObject) && VRCPlayerApi.GetPlayerCount() == 1)
            {
                SyncedHasLateJoiner = false;
            }
        }

        public override void OnOwnershipTransferred(VRCPlayerApi player)
        {
            if (player.isLocal && SyncedHasLateJoiner)
            {
                if (VRCPlayerApi.GetPlayerCount() == 1)
                {
                    SyncedHasLateJoiner = false;
                }
                else
                {
                    syncAllOneMore = false;
                    lateJoinerDataIdListIndex = 0;
                    SendLateJoinerData();
                }
            }
        }

        public void SendLateJoinerData()
        {
            if (!Networking.IsOwner(gameObject) || !SyncedHasLateJoiner) return;

            if (Networking.IsClogged)
            {
                SendCustomEventDelayedSeconds(
                    nameof(SendLateJoinerData),
                    3.0f
                );
                return;
            }

            int totalPositions = 0;
            while (totalPositions < maxChunkSize)
            {
                if (lateJoinerDataIdListIndex >= dataIdList.Count || dataIdList[lateJoinerDataIdListIndex].ULong > lateJoinerSyncLastDataId)
                {
                    if (syncAllOneMore)
                    {
                        lateJoinerDataIdListIndex = 0;
                        syncAllOneMore = false;
                        lateJoinerSyncLastDataId = oneMoreLastDataId;
                        continue;
                    }
                    else
                    {
                        SyncedHasLateJoiner = false;
                        break;
                    }
                }

                ulong targetDataId = dataIdList[lateJoinerDataIdListIndex].ULong;
                if (!linePoolDataId.ContainsKey(targetDataId)) 
                {
                    lateJoinerDataIdListIndex++;
                    continue;
                }
                DataDictionary linePoolDataIdData = linePoolDataId[targetDataId].DataDictionary;
                int playerId = linePoolDataIdData["playerId"].Int;
                int lineId = linePoolDataIdData["lineId"].Int;
                int chunkId = linePoolDataIdData["chunkId"].Int;

                if (linePool.ContainsKey(playerId))
                {
                    DataDictionary playerDict = linePool[playerId].DataDictionary;
                    if (playerDict.ContainsKey(lineId))
                    {
                        DataDictionary lineData = playerDict[lineId].DataDictionary;
                        DataDictionary chunks = lineData["chunks"].DataDictionary;
                        if (chunks.ContainsKey(chunkId))
                        {
                            DataDictionary chunkData = chunks[chunkId].DataDictionary;
                            DataList positionsDataList = chunkData["positions"].DataList;
                            Vector3[] positions = Vector3ArrayFromDataList(positionsDataList);

                            totalPositions += positions.Length;

                            SendCustomNetworkEvent(
                                VRC.Udon.Common.Interfaces.NetworkEventTarget.Others,
                                nameof(SetLine),
                                playerId,
                                lineId,
                                chunkId,
                                FromHtmlStringRGBA(lineData["lineColor"].String),
                                lineData["lineWidth"].Float,
                                lineData["layerId"].Byte,
                                positions
                            );
                        }
                    }
                }

                lateJoinerDataIdListIndex++;
            }

            if (SyncedHasLateJoiner)
            {
                SendCustomEventDelayedSeconds(
                    nameof(SendLateJoinerData),
                    0.25f
                );
            }
        }

        private bool SyncedHasLateJoiner
        {
            set
            {
                syncedHasLateJoiner = value;
                
                if (Networking.IsOwner(gameObject))
                {
                    RequestSerialization();
                }
            }
            get => syncedHasLateJoiner;
        }
    }
}
