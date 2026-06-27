
using System;
using System.Security.Policy;
using UdonSharp;
using UnityEngine;
using VRC.SDK3.Data;
using VRC.SDKBase;
using VRC.Udon;

namespace Swingly.AvatarJson
{
    public class PedestalManager : UdonSharpBehaviour
    {
        [SerializeField] private JsonAvatarLoader avatarLoader;
        [SerializeField] private int pageSize = 20;

        private DataList avatars;
        private AvatarPedestal[] avatarPedestals;
        private bool pedestalsFound = false;
        private int currentPage = 1;
        private int pageCount = 1;

        void Start()
        {
            avatarPedestals = GetComponentsInChildren<AvatarPedestal>();
            Debug.Log($"Found {avatarPedestals.Length} pedestals!");

            for (int i = 0; i < avatarPedestals.Length; i++)
            {
                avatarPedestals[i].gameObject.SetActive(false);
            }
            pedestalsFound = true;

            //check in case we missed a call before pedestals were found
            if (avatarLoader.jsonLoaded)
            {
                LoadAvatars(avatarLoader.avatars);
            }
        }

        private void UpdatePedestals()
        {
            for (int i = 0; i < avatarPedestals.Length; i++)
            {
                avatarPedestals[i].gameObject.SetActive(false);
            }

            for (int i = 0; i < avatars.Count - (currentPage * pageSize) + pageSize && i < avatarPedestals.Length; i++)
            {
                avatarPedestals[i].gameObject.SetActive(true);
                //Debug.Log("Switching Pedestal " + i);
                avatarPedestals[i].SwitchAvatar(avatars[i + currentPage * pageSize - pageSize].DataDictionary);
            }
        }

        public void LoadAvatars(DataList avatarList)
        {
            if (pedestalsFound)
            {
                Debug.Log("Updating pedestals");
                avatars = avatarList;
                pageCount = avatars.Count / (pageSize + 1) + 1;
                currentPage = 1;
                UpdatePedestals();
            }
        }

        public void ApplyFilter(string tag)
        {
            if (tag == "all")
            {
                LoadAvatars(avatarLoader.avatars);
                return;
            }

            DataList sourceAvatars = avatarLoader.avatars;
            DataList taggedAvatars = new DataList();
            DataToken tagToken = new DataToken(tag);

            for (int i = 0; i < sourceAvatars.Count; i++)
            {
                if(sourceAvatars[i].DataDictionary["tags"].DataList.Contains(tagToken))
                {
                    taggedAvatars.Add(sourceAvatars[i]);
                }
            }

            LoadAvatars(taggedAvatars);
        }

        public void NextPage()
        {
            if (currentPage < pageCount)
            {
                //Debug.Log($"Current page: {currentPage}\nPage count: {pageCount}");
                currentPage++;
                UpdatePedestals();
            }
        }

        public void PreviousPage()
        {
            if (currentPage > 1)
            {
                currentPage--;
                UpdatePedestals();
            }
        }
    }
}

