
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
        if (carController != null && theTrigger.bounds.Contains(Networking.LocalPlayer.GetPosition()))
            carController.GlobalVolume = newVolume;
    }

    private void OnDisable()
    {
        if (carController) carController.GlobalVolume = newVolume;
    }

    public override void OnPlayerTriggerEnter(VRCPlayerApi player)
    {
        if (!player.isLocal) return;
        if (carController) carController.GlobalVolume = newVolume;
    }

    public override void OnPlayerTriggerExit(VRCPlayerApi player)
    {
        if (!player.isLocal) return; 
        if (carController) carController.GlobalVolume = 1f;
    }
}
