
using UdonSharp;
using UnityEngine;
using VRC.SDK3.Rendering;
using VRC.SDKBase;
using VRC.Udon;

public class CameraDepthEnable : UdonSharpBehaviour
{
    void Start()
    {
        VRCCameraSettings.ScreenCamera.DepthTextureMode = DepthTextureMode.Depth;
    }
}
