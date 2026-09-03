
using Texel;
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class WallAdminPanel : UdonSharpBehaviour
{ 
    public AccessControl accessControl;
    public GameObject[] stageParts;
    [UdonSynced] public bool partsEnabled;
    public GameObject buttonPanelObject;
    public bool AllowEveryoneLOL = false;

    // void Start()
    // {
    //     this.enabled = accessControl._LocalWhitelisted();   
    // }

    public override void OnPlayerJoined(VRCPlayerApi player)
    {
        if (AllowEveryoneLOL) return;
        if (player.isLocal)
        {
            buttonPanelObject.SetActive(accessControl._HasAccess(Networking.LocalPlayer));
            SendCustomEventDelayedSeconds(nameof(PermisisonCheck), 60);
        }
    }

    public void PermisisonCheck()
    {
            buttonPanelObject.SetActive(accessControl._HasAccess(Networking.LocalPlayer));
    }
    
    public void OnButton()
    {
        partsEnabled = true;
        ObjectToggleFunction();
        if (AllowEveryoneLOL) return;
        RequestSerialization();
    }

    public void OffButton()
    {
        partsEnabled = false;
        ObjectToggleFunction();
        if (AllowEveryoneLOL) return;
        RequestSerialization();
    }
    
    public override void OnDeserialization()
    {
        if (AllowEveryoneLOL) return;
        ObjectToggleFunction();
    }
    
    public void ObjectToggleFunction()
    {
        foreach (GameObject stagePart in stageParts)
        {
            stagePart.SetActive(partsEnabled);
        }
    }
    
}
