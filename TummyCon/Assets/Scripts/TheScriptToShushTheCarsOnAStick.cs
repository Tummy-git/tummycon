using System;
using pi.coas;
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using VRRefAssist;

public class TheScriptToShushTheCarsOnAStick : UdonSharpBehaviour
{
    [SerializeField, FindObjectOfType] private CarOnAStickGlobalVolumeController carController;
    private Collider theTrigger;
    public float newVolume = 0.2f;

    private void Start()
    {
        theTrigger = GetComponent<Collider>();
    }

    private void OnEnable()
    {
        if (carController == null || theTrigger == null) return;

        VRCPlayerApi localPlayer = Networking.LocalPlayer;
        
        if (!Utilities.IsValid(localPlayer)) return;

        if (theTrigger.bounds.Contains(localPlayer.GetPosition()))
        {
            carController.GlobalVolume = newVolume;
        }
    }

    private void OnDisable()
    {
        if (carController != null) 
        {
            carController.GlobalVolume = 1f;
        }
    }

    public override void OnPlayerTriggerEnter(VRCPlayerApi player)
    {
        if (!Utilities.IsValid(player) || !player.isLocal) return;
        
        if (carController != null) 
        {
            carController.GlobalVolume = newVolume;
        }
    }

    public override void OnPlayerTriggerExit(VRCPlayerApi player)
    {
        if (!Utilities.IsValid(player) || !player.isLocal) return; 
        
        if (carController != null) 
        {
            carController.GlobalVolume = 1f;
        }
    }
}