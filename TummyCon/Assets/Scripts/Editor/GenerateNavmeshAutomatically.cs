using System;
using com.vrcstuff.udon;
using Unity.AI.Navigation;
using UnityEditor;
using UnityEngine;
using VRC.SDKBase;
using VRC.SDKBase.Editor;
using VRC.SDKBase.Editor.BuildPipeline;

public class GenerateNavmeshAutomatically : IVRCSDKBuildRequestedCallback
{
    // Priority for build pipeline execution order
    public int callbackOrder => 100;

    [InitializeOnLoadMethod]
    public static void RegisterCallbacks()
    {
        VRCSdkControlPanel.OnSdkPanelEnable += AddBuildHook;

        // Subscribe to Play Mode state changes to handle merging before Play Mode starts
        EditorApplication.playModeStateChanged += OnPlayModeStateChanged; // <-- Added
    }

// Merges scenes before Play Mode starts
    private static void OnPlayModeStateChanged(PlayModeStateChange state) // <-- Added
    {
        if (state == PlayModeStateChange.ExitingEditMode) // <-- Added
        {
            FindAndBakeNavmesh();
        }
    }

    public static void FindAndBakeNavmesh()
    {
        NavMeshSurface navMeshSurface = GameObject.FindObjectOfType<NavMeshSurface>();

        if (Utilities.IsValid(navMeshSurface))
        {
            Utils.Log(typeof(GenerateNavmeshAutomatically).Name, $"Found NavMeshSurface on GameObject: {navMeshSurface.gameObject.name}");

            // Bake the NavMesh for this NavMeshSurface
            navMeshSurface.BuildNavMesh();
            Debug.Log("NavMesh baking complete.");
        }
        else
        {
            Utils.LogWarning(typeof(GenerateNavmeshAutomatically).Name, "No NavMeshSurface found in the scene.");
        }
    }

    [InitializeOnLoadMethod]
    public static void RegisterSDKCallback()
    {
        VRCSdkControlPanel.OnSdkPanelEnable += AddBuildHook;
    }

    private static void AddBuildHook(object sender, EventArgs e)
    {
        if (VRCSdkControlPanel.TryGetBuilder<IVRCSdkBuilderApi>(out var builder))
        {
            builder.OnSdkBuildStart += OnBuildStart;
        }
    }

    private static void OnBuildStart(object sender, object e)
    {
        // FindAndBakeNavmesh();
    }

    public bool OnBuildRequested(VRCSDKRequestedBuildType requestedBuildType)
    {
        FindAndBakeNavmesh();
        return true;
    }
}