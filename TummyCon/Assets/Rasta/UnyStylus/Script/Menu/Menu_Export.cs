
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDK3.Data;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    public class Menu_Export : UdonSharpBehaviour
    {
        [SerializeField] private UnyStylusController controller;
        [SerializeField] private LineSelector unyStylusSelector;
        [SerializeField] private InputField jsonOutputField;
        [SerializeField] private GameObject jsonOutputFieldCanvas;
        [SerializeField] private Animator animator;
        [SerializeField] private PlayerPopup playerPopup;

        private int exportMode = 0; // 0: All, 1: Selection

        private DataDictionary emptyDataDict = new DataDictionary();

        [UdonSynced, FieldChangeCallback(nameof(SyncedIsOpenExportPopup))] private bool syncedIsOpenExportPopup;

        public void OnMenuClosed()
        {
            if (Networking.IsOwner(gameObject))
            {
                SyncedIsOpenExportPopup = false;
            }
        }

        public void OpenPopup()
        {
            SyncedIsOpenExportPopup = true;
        }

        public void ClosePopup()
        {
            SyncedIsOpenExportPopup = false;
        }

        // Select Mode
        public void OnClickExportAll()
        {
            exportMode = 0;

            int totalLineCount = 0;

            DataDictionary linePool = controller.linePool.GetLinePool();
            DataList playerIds = linePool.GetKeys();
            for (int i = 0; i < playerIds.Count; i++)
            {
                int playerId = playerIds[i].Int;
                DataDictionary playerDict = linePool[playerId].DataDictionary;
                totalLineCount += playerDict.Count;
            }

            if (totalLineCount > 1000)
            {
                animator.SetBool("isOpenLineCountWarning", true);
            }
            else
            {
                animator.SetBool("isOpenExportConfirmPopup", true);
            }
        }

        public void OnClickExportSelection()
        {
            exportMode = 1;

            if (unyStylusSelector.GetSelectedLines().Count > 1000)
            {
                animator.SetBool("isOpenLineCountWarning", true);
            }
            else
            {
                ExportSelection();
            }
        }

        // Warnings
        public void ConfirmLineCountWarning()
        {
            if (exportMode == 0)
            {
                animator.SetBool("isOpenLineCountWarning", false);
                animator.SetBool("isOpenExportConfirmPopup", true);
            }
            else if (exportMode == 1)
            {
                animator.SetBool("isOpenLineCountWarning", false);
                ExportSelection();
            }
        }

        public void CancelLineCountWarning()
        {
            animator.SetBool("isOpenLineCountWarning", false);
        }

        public void ConfirmExportAllNotify()
        {
            ExportAll();
            animator.SetBool("isOpenExportConfirmPopup", false);
        }

        public void CancelExportAllNotify()
        {
            animator.SetBool("isOpenExportConfirmPopup", false);
        }

        // Export Functions
        private void ExportSelection()
        {
            DataList selectedLines = unyStylusSelector.GetSelectedLines();
            DataDictionary selectedLineDict = emptyDataDict.DeepClone();
            DataDictionary linePool = controller.linePool.GetLinePool();
            for (int i = 0; i < selectedLines.Count; i++)
            {
                string[] parts = selectedLines[i].String.Split('_');
                int playerId = int.Parse(parts[0]);
                int lineId = int.Parse(parts[1]);

                if (!linePool.ContainsKey(playerId)) continue;
                if (!linePool[playerId].DataDictionary.ContainsKey(lineId)) continue;
                if (!selectedLineDict.ContainsKey(playerId))
                {
                    selectedLineDict[playerId] = emptyDataDict.DeepClone();
                }
                if (!selectedLineDict[playerId].DataDictionary.ContainsKey(lineId))
                {
                    selectedLineDict[playerId].DataDictionary[lineId] = linePool[playerId].DataDictionary[lineId];
                }
            }
            string jsonString = ConvertToJson(selectedLineDict);
            jsonOutputField.text = jsonString;
            jsonOutputFieldCanvas.SetActive(true);
        }

        private void ExportAll()
        {
            string jsonString = ConvertToJson(controller.linePool.GetLinePool());
            jsonOutputField.text = jsonString;
            jsonOutputFieldCanvas.SetActive(true);
            playerPopup.SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, nameof(PlayerPopup.NotifySaveAllStrokes), Networking.LocalPlayer.playerId);
        }

        private bool SyncedIsOpenExportPopup
        {
            set
            {
                syncedIsOpenExportPopup = value;

                animator.SetBool("isOpenExportPopup", syncedIsOpenExportPopup);
                animator.SetBool("isEnableMenuBlock", syncedIsOpenExportPopup);

                if (!syncedIsOpenExportPopup)
                {
                    animator.SetBool("isOpenLineCountWarning", false);
                    animator.SetBool("isOpenExportConfirmPopup", false);
                }

                if (Networking.IsOwner(gameObject))
                {
                    RequestSerialization();
                }
            }
            get => syncedIsOpenExportPopup;
        }


        private string ConvertToJson(DataDictionary dict)
        {
            // Convert Key to String
            DataDictionary newDict = emptyDataDict.DeepClone();
            DataList playerIds = dict.GetKeys();
            for (int i = 0; i < playerIds.Count; i++)
            {
                int playerId = playerIds[i].Int;
                DataDictionary newPlayerDict = emptyDataDict.DeepClone();
                DataDictionary playerDict = dict[playerId].DataDictionary;
                DataList objectIds = playerDict.GetKeys();
                for (int j = 0; j < objectIds.Count; j++)
                {
                    int objectId = objectIds[j].Int;
                    DataDictionary lineData = playerDict[objectId].DataDictionary;
                    DataDictionary newLineData = emptyDataDict.DeepClone();
                    newLineData["c"] = lineData["lineColor"];
                    newLineData["w"] = lineData["lineWidth"];
                    DataDictionary chunks = lineData["chunks"].DataDictionary;
                    DataDictionary newChunks = emptyDataDict.DeepClone();
                    DataList chunkIds = chunks.GetKeys();
                    for (int k = 0; k < chunkIds.Count; k++)
                    {
                        int chunkId = chunkIds[k].Int;
                        DataDictionary chunkData = chunks[chunkId].DataDictionary;
                        DataDictionary newChunkData = emptyDataDict.DeepClone();
                        newChunkData["p"] = Base64FromVector3DataList(chunkData["positions"].DataList);
                        newChunks[chunkId.ToString()] = newChunkData;
                    }
                    newLineData["h"] = newChunks;
                    newPlayerDict[objectId.ToString()] = newLineData;
                }
                newDict[playerId.ToString()] = newPlayerDict;
            }

            DataDictionary exportDict = emptyDataDict.DeepClone();
            exportDict["version"] = 1;
            exportDict["data"] = newDict;

            VRCJson.TrySerializeToJson(exportDict, JsonExportType.Minify, out DataToken jsonToken);
            return jsonToken.String;
        }

        private string Base64FromVector3DataList(DataList dataList)
        {
            int count = dataList.Count;
            byte[] bytes = new byte[count * 3 * 4];
            for (int i = 0; i < count; i++)
            {
                DataList pos = dataList[i].DataList;
                int offset = i * 12;
                System.Buffer.BlockCopy(System.BitConverter.GetBytes(pos[0].Float), 0, bytes, offset + 0, 4);
                System.Buffer.BlockCopy(System.BitConverter.GetBytes(pos[1].Float), 0, bytes, offset + 4, 4);
                System.Buffer.BlockCopy(System.BitConverter.GetBytes(pos[2].Float), 0, bytes, offset + 8, 4);
            }
            return System.Convert.ToBase64String(bytes);
        }
    }
}
