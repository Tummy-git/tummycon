using UdonSharp;
using UnityEngine;
using VRC.SDK3.Rendering;
using VRC.Udon;

[UdonBehaviourSyncMode(BehaviourSyncMode.NoVariableSync)]
public class LEDBarLightVideoInput : UdonSharpBehaviour
{
    private const string ReceiverTextureProperty = "_MainTex";
    private const string BarLightTextureProperty = "_MovieTex";
    private const int MaxDepthApplyRetries = 30;

    [SerializeField] private bool ForceScreenCameraDepth;
    [SerializeField] private bool VideoInputEnabled;
    [SerializeField] private int VideoInputSourceMode;
    [SerializeField] private GameObject VideoInputPlayerRoot;
    [SerializeField] private string VideoInputProviderName = "";
    [SerializeField] private Renderer VideoInputReceiverRenderer;
    [SerializeField] private UdonBehaviour VideoInputSourceBehaviour;
    [SerializeField] private string VideoInputSourceVariable = "";
    [SerializeField] private Texture VideoInputDirectTexture;
    [SerializeField] private Material[] TargetMaterials;
    [SerializeField, Min(0.1f)] private float VideoInputRefreshInterval = 0.5f;

    private MaterialPropertyBlock receiverPropertyBlock;
    private Texture currentTexture;
    private bool screenCameraDepthApplied;
    private int depthApplyRetryCount;

    private void Start()
    {
        if (ForceScreenCameraDepth)
        {
            _ApplyScreenCameraDepth();
        }

        if (!VideoInputEnabled)
        {
            return;
        }

        receiverPropertyBlock = new MaterialPropertyBlock();
        _RefreshVideoInput();
    }

    private void _ApplyScreenCameraDepth()
    {
        if (!ForceScreenCameraDepth || screenCameraDepthApplied)
        {
            return;
        }

        VRCCameraSettings screenCamera = VRCCameraSettings.ScreenCamera;
        if (screenCamera == null)
        {
            if (depthApplyRetryCount < MaxDepthApplyRetries)
            {
                depthApplyRetryCount++;
                SendCustomEventDelayedSeconds(
                    nameof(_RetryScreenCameraDepth),
                    1.0f);
            }
            return;
        }

        int currentMode = (int)screenCamera.DepthTextureMode;
        int depthMode = (int)DepthTextureMode.Depth;
        screenCamera.DepthTextureMode =
            (DepthTextureMode)(currentMode | depthMode);
        screenCameraDepthApplied = true;
    }

    public void _RetryScreenCameraDepth()
    {
        _ApplyScreenCameraDepth();
    }

    public void _RefreshVideoInput()
    {
        if (!VideoInputEnabled)
        {
            return;
        }

        Texture resolvedTexture = ResolveTexture();
        if (resolvedTexture != null && resolvedTexture != currentTexture)
        {
            currentTexture = resolvedTexture;
            ApplyTexture(resolvedTexture);
        }

        SendCustomEventDelayedSeconds(
            nameof(_RefreshVideoInput),
            Mathf.Max(0.1f, VideoInputRefreshInterval));
    }

    private Texture ResolveTexture()
    {
        if (VideoInputSourceMode == 1 && VideoInputReceiverRenderer != null)
        {
            if (receiverPropertyBlock == null)
            {
                receiverPropertyBlock = new MaterialPropertyBlock();
            }

            VideoInputReceiverRenderer.GetPropertyBlock(receiverPropertyBlock, 0);
            Texture receivedTexture = receiverPropertyBlock.GetTexture(
                ReceiverTextureProperty);
            if (receivedTexture != null)
            {
                return receivedTexture;
            }

            Material receiverMaterial = VideoInputReceiverRenderer.sharedMaterial;
            if (receiverMaterial != null)
            {
                return receiverMaterial.GetTexture(ReceiverTextureProperty);
            }
        }
        else if (VideoInputSourceMode == 2 &&
                 VideoInputSourceBehaviour != null &&
                 !string.IsNullOrEmpty(VideoInputSourceVariable))
        {
            return (Texture)VideoInputSourceBehaviour.GetProgramVariable(
                VideoInputSourceVariable);
        }
        else if (VideoInputSourceMode == 3)
        {
            return VideoInputDirectTexture;
        }

        return null;
    }

    private void ApplyTexture(Texture texture)
    {
        if (TargetMaterials == null)
        {
            return;
        }

        for (int i = 0; i < TargetMaterials.Length; i++)
        {
            Material targetMaterial = TargetMaterials[i];
            if (targetMaterial == null)
            {
                continue;
            }

            targetMaterial.SetTexture(BarLightTextureProperty, texture);
        }
    }
}
