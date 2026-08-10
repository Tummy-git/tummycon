
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    public class DesktopTextureChanger : UdonSharpBehaviour
    {
        [SerializeField] private Image shortCuts;
        [SerializeField] private Sprite desktopShortCutSprite;
        [Space(10)]
        [SerializeField] private Image menuShortCut;
        [SerializeField] private Sprite desktopMenuShortCutSprite;

        void Start()
        {
            if (!Networking.LocalPlayer.IsUserInVR())
            {
                shortCuts.sprite = desktopShortCutSprite;
                menuShortCut.sprite = desktopMenuShortCutSprite;
            }
        }
    }
}
