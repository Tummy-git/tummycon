using UdonSharp;
using UnityEngine;
using VRC.SDK3.StringLoading;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.UI;
using VRC.Udon.Common.Interfaces;
using VRC.SDK3.Data;
using System;
using UnityEngine.UIElements;
using TMPro;

namespace Swingly.AvatarJson
{
    public class JsonAvatarLoader : UdonSharpBehaviour
    {
        [SerializeField] private VRCUrl[] urls;
        [SerializeField] private TextMeshProUGUI textField;
        [SerializeField] private string[] fallbackJsons;
        [SerializeField] private PedestalManager pedestalManager;
        [SerializeField] private bool debug = false;

        [NonSerialized] public DataList avatars;
        [NonSerialized] public bool jsonLoaded;

        private DataDictionary versionInfo;
        private int selectedURL = 0;

        private void Start()
        {
            VRCStringDownloader.LoadUrl(urls[0], (IUdonEventReceiver)this);
        }

        public override void OnStringLoadSuccess(IVRCStringDownload result)
        {
            textField.text = result.Result;
            Debug.Log("Loaded avatar JSON string successfully");

            //read fallback if reading fails
            if (!ReadJson(result.Result))
            {
                ReadJson(fallbackJsons[selectedURL]);
            }
        }

        public override void OnStringLoadError(IVRCStringDownload result)
        {
            Debug.Log("String failed to load!");
            textField.text = "String failed to load!";
            //textField.text = result.Result;
            //Debug.Log(result.ToString());
            ReadJson(fallbackJsons[selectedURL]);
        }

        private bool ReadJson(string json)
        {
            if (VRCJson.TryDeserializeFromJson(json, out DataToken result))
            {
                if (result.TokenType == TokenType.DataDictionary)
                {
                    avatars = result.DataDictionary["avatars"].DataList;
                    versionInfo = result.DataDictionary["versioninfo"].DataDictionary;
                    jsonLoaded = true;

                    PrintAvatarData(avatars);
                    pedestalManager.LoadAvatars(avatars);
                    return true;
                }

                Debug.Log("No DataDictionary Found!");
                textField.text = "No DataDictionary Found!";
                return false;
            }
            else
            {
                string errorText = result.ToString();
                textField.text = result.ToString();
                Debug.Log(errorText);
                return false;
            }
        }

        private void PrintAvatarData(DataList avatars)
        {
            textField.text = "";
            if (debug)
            {
                for (int i = 0; i < avatars.Count; i++)
                {
                    string avatarName = avatars[i].DataDictionary["name"].ToString();
                    string blueprintid = avatars[i].DataDictionary["blueprintid"].ToString();
                    string author = avatars[i].DataDictionary["author"].ToString();
                    string description = avatars[i].DataDictionary["description"].ToString();
                    string tags = "";
                    for (int t = 0; t < avatars[i].DataDictionary["tags"].DataList.Count; t++)
                    {
                        tags += avatars[i].DataDictionary["tags"].DataList[t].ToString();
                        if (t < avatars[i].DataDictionary["tags"].DataList.Count - 1) { tags += ", "; }
                    }
                    textField.text += $"{avatarName}\n    ID: {blueprintid}\n    Author: {author}\n    Description: {description}\n    Tags: {tags}\n";
                }
            }

            textField.text += $"<color=yellow>List: {versionInfo["name"]}\nVersion: {versionInfo["version"]}\nLast Updated: {versionInfo["date"]}</color>\n";
            textField.text += $"<color=green>Found {avatars.Count} avatars!</color>\n";
        }

        //this is the first URL in the array
        public void LoadMainURL()
        {
            if (selectedURL != 0)
            {
                selectedURL = 0;
                VRCStringDownloader.LoadUrl(urls[selectedURL], (IUdonEventReceiver)this);
            }
        }

        //second URL in the array
        public void LoadSecondaryURL()
        {
            if (selectedURL != 1)
            {
                selectedURL = 1;
                VRCStringDownloader.LoadUrl(urls[selectedURL], (IUdonEventReceiver)this);
            }
        }
    }
}

