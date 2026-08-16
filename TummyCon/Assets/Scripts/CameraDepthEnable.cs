
using System;
using UdonSharp;
using UnityEngine;
using VRC.SDK3.Rendering;
using VRC.SDKBase;
using VRC.Udon;


public class CameraDepthEnable : UdonSharpBehaviour
{

    // private DepthTextureMode _savedDepthTextureState;

    void Start()
    {
        // VRCCameraSettings.ScreenCamera.DepthTextureMode = _savedDepthTextureState;
        VRCCameraSettings.ScreenCamera.DepthTextureMode = DepthTextureMode.Depth;
    }
    //
    // public override void OnPlayerTriggerEnter(VRCPlayerApi player)
    // {
    //     VRCCameraSettings.ScreenCamera.DepthTextureMode = DepthTextureMode.Depth;
    // }
    //
    // public override void OnPlayerTriggerExit(VRCPlayerApi player)
    // {
    //     _savedDepthTextureState = VRCCameraSettings.ScreenCamera.DepthTextureMode;
    // }
}