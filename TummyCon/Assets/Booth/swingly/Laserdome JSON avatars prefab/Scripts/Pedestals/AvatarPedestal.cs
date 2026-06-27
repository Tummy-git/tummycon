
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using VRC.SDK3.Data;
using UnityEngine.UI;
using TMPro;

namespace Swingly.AvatarJson
{
    [RequireComponent(typeof(VRC_AvatarPedestal))]
    public class AvatarPedestal : UdonSharpBehaviour
    {
        [SerializeField] private TextMeshProUGUI nameText;

        private VRC_AvatarPedestal pedestal;

        private void Start()
        {
            pedestal = GetComponent<VRC_AvatarPedestal>();
        }

        public override void Interact()
        {
            EquipAvatar();
        }

        public void EquipAvatar()
        {
            pedestal.SetAvatarUse(Networking.LocalPlayer);
            Debug.Log("Equipped Avatar!");
        }

        public void SwitchAvatar(DataDictionary avatarData)
        {
            if (avatarData.TryGetValue("blueprintid", out DataToken blueprintid))
            {
                pedestal.SwitchAvatar(blueprintid.ToString());
            }
            else
            {
                Debug.Log("No blueprintid in Dictionary!");
                this.gameObject.SetActive(false);
                return;
            }

            if(nameText != null)
            {
                UpdateMenuInfo(avatarData);
            }
        }

        private void UpdateMenuInfo(DataDictionary avatarData)
        {
            if (avatarData.TryGetValue("name", out DataToken name))
            {
                nameText.text = name.ToString();
            }
            else
            {
                nameText.text = "Name missing!";
                Debug.Log("No name in Dictionary!");
            }
        }
    }
}