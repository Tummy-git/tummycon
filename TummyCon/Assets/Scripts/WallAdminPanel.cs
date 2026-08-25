
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
    // void Start()
    // {
    //     this.enabled = accessControl._LocalWhitelisted();   
    // }

    public override void OnPlayerJoined(VRCPlayerApi player)
    {
        if (player.isLocal)
        {
            buttonPanelObject.SetActive(accessControl._HasAccess(player));
        }
    }

    public void OnButton()
    {
        partsEnabled = true;
        ObjectToggleFunction();
        RequestSerialization();
    }

    public void OffButton()
    {
        partsEnabled = false;
        ObjectToggleFunction();
        RequestSerialization();
    }
    
    public override void OnDeserialization()
    {
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
