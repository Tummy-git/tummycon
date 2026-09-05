using Texel;
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class WallAdminPanel : UdonSharpBehaviour
{ 
    public AccessControl accessControl;
    public GameObject[] stageParts;
    [UdonSynced] public bool partsEnabled = false;
    public GameObject buttonPanelObject;
    [SerializeField] private bool AllowEveryoneLOL = false;

    void Start()
    {
        PermissionCheck();
        ObjectToggleFunction();
        
        SendCustomEventDelayedSeconds(nameof(PermissionCheck), 60);
    }

    public void PermissionCheck()
    {
        if (AllowEveryoneLOL)
        {
            buttonPanelObject.SetActive(true);
        }
        else
        {
            buttonPanelObject.SetActive(accessControl._HasAccess(Networking.LocalPlayer));
        }
    }
    
    public void OnButton()
    {
        // 1. Take ownership FIRST
        if(!Networking.LocalPlayer.IsOwner(gameObject)) 
        {
            Networking.SetOwner(Networking.LocalPlayer, gameObject);
        }
        
        // 2. Modify synced variables SECOND
        partsEnabled = true;
        
        // 3. Apply visuals and sync THIRD
        ObjectToggleFunction();
        RequestSerialization(); 
    }

    public void OffButton()
    {
        // 1. Take ownership FIRST
        if(!Networking.LocalPlayer.IsOwner(gameObject)) 
        {
            Networking.SetOwner(Networking.LocalPlayer, gameObject);
        }
        
        // 2. Modify synced variables SECOND
        partsEnabled = false;
        
        // 3. Apply visuals and sync THIRD
        ObjectToggleFunction();
        RequestSerialization(); 
    }
    
    public override void OnDeserialization()
    {
        ObjectToggleFunction();
    }
    
    public void ObjectToggleFunction()
    {
        // This function now exclusively handles the physical objects. 
        // No ownership checks belong here.
        foreach (GameObject stagePart in stageParts)
        {
            stagePart.SetActive(partsEnabled);
        }
    }
}