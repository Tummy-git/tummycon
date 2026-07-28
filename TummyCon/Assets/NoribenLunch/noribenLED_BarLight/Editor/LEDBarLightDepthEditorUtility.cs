#if UNITY_EDITOR
using UdonSharpEditor;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using VRC.SDK3.Rendering;

internal static class LEDBarLightDepthEditorUtility
{
    public static void Draw(
        LEDBarLightVideoInput runtimeSupport,
        Material[] targetMaterials,
        bool isJapanese)
    {
        EditorGUILayout.LabelField(
            isJapanese ? "環境診断" : "Environment Diagnostics",
            EditorStyles.boldLabel);
        EditorGUILayout.BeginVertical(EditorStyles.helpBox);
        LEDBarLightAudioLinkEditorUtility.DrawDiagnostic(
            targetMaterials,
            isJapanese);
        EditorGUILayout.Space(8f);
        EditorGUILayout.LabelField(
            "Camera Depth Texture",
            EditorStyles.boldLabel);

        if (runtimeSupport == null)
        {
            EditorGUILayout.HelpBox(
                isJapanese
                    ? "LED BarLight Runtime Supportが見つからないため、Depth設定を変更できません。"
                    : "LED BarLight Runtime Support was not found, so the Depth setting cannot be changed.",
                MessageType.Error);
            EditorGUILayout.EndVertical();
            return;
        }

        SerializedObject runtimeObject =
            new SerializedObject(runtimeSupport);
        runtimeObject.Update();
        SerializedProperty forceDepthProperty =
            runtimeObject.FindProperty("ForceScreenCameraDepth");
        if (forceDepthProperty == null)
        {
            EditorGUILayout.HelpBox(
                isJapanese
                    ? "Screen Camera Depth設定が見つかりません。"
                    : "The Screen Camera Depth setting was not found.",
                MessageType.Error);
            EditorGUILayout.EndVertical();
            return;
        }

        bool runtimeDepthEnabled = HasRuntimeScreenCameraDepth();
        int shadowDirectionalLightCount =
            CountActiveShadowDirectionalLights();
        bool forceDepthEnabled = forceDepthProperty.boolValue;
        bool depthAvailable = forceDepthEnabled ||
                              runtimeDepthEnabled ||
                              shadowDirectionalLightCount > 0;

        DrawStatusLine(
            depthAvailable,
            depthAvailable
                ? (isJapanese
                    ? "Camera Depth Texture：利用可能"
                    : "Camera Depth Texture: Available")
                : (isJapanese
                    ? "Camera Depth Texture：未設定"
                    : "Camera Depth Texture: Not Configured"));

        if (runtimeDepthEnabled)
        {
            EditorGUILayout.LabelField(
                isJapanese
                    ? "Screen CameraでDepthが有効です。"
                    : "Depth is enabled on the Screen Camera.",
                EditorStyles.wordWrappedMiniLabel);
        }
        else if (forceDepthEnabled)
        {
            EditorGUILayout.LabelField(
                isJapanese
                    ? "ワールド起動時にScreen Camera Depthを有効化します。"
                    : "Screen Camera Depth will be enabled when the world starts.",
                EditorStyles.wordWrappedMiniLabel);
        }
        else if (shadowDirectionalLightCount > 0)
        {
            EditorGUILayout.LabelField(
                isJapanese
                    ? $"影付きDirectional Lightを検出しました（{shadowDirectionalLightCount}灯）。"
                    : $"Found shadow-casting Directional Light(s): {shadowDirectionalLightCount}.",
                EditorStyles.wordWrappedMiniLabel);
        }
        else
        {
            EditorGUILayout.HelpBox(
                isJapanese
                    ? "Depth設定と影付きDirectional Lightがありません。バーライトと床・壁・オブジェクトの交差部分をソフトに遮蔽できません。"
                    : "No Depth setting or shadow-casting Directional Light was found. Soft depth occlusion at intersections with scene geometry will not be available.",
                MessageType.Error);

            if (GUILayout.Button(
                    isJapanese
                        ? "Screen Camera Depthを有効化"
                        : "Enable Screen Camera Depth",
                    GUILayout.Height(26f)))
            {
                Undo.RecordObject(
                    runtimeSupport,
                    isJapanese
                        ? "Screen Camera Depthを有効化"
                        : "Enable Screen Camera Depth");
                forceDepthProperty.boolValue = true;
                runtimeObject.ApplyModifiedProperties();
                ApplyRuntimeChanges(runtimeSupport);
                GUI.changed = true;
            }
        }

        EditorGUILayout.EndVertical();
    }

    public static void DrawStatusLine(bool ready, string text)
    {
        EditorGUILayout.BeginHorizontal();
        Color previousContentColor = GUI.contentColor;
        GUI.contentColor = ready
            ? new Color(0.2f, 0.85f, 0.3f)
            : new Color(1.0f, 0.35f, 0.35f);
        EditorGUILayout.LabelField(
            ready ? "✓" : "✖",
            GUILayout.Width(16.0f));
        GUI.contentColor = previousContentColor;
        EditorGUILayout.LabelField(text);
        EditorGUILayout.EndHorizontal();
    }

    private static bool HasRuntimeScreenCameraDepth()
    {
        if (!Application.isPlaying ||
            VRCCameraSettings.ScreenCamera == null)
        {
            return false;
        }

        return (VRCCameraSettings.ScreenCamera.DepthTextureMode &
                DepthTextureMode.Depth) != 0;
    }

    private static int CountActiveShadowDirectionalLights()
    {
        Light[] lights = Object.FindObjectsByType<Light>(
            FindObjectsInactive.Include,
            FindObjectsSortMode.None);
        int count = 0;

        for (int i = 0; i < lights.Length; i++)
        {
            Light light = lights[i];
            if (light == null ||
                !light.isActiveAndEnabled ||
                light.type != LightType.Directional ||
                light.shadows == LightShadows.None ||
                light.lightmapBakeType == LightmapBakeType.Baked)
            {
                continue;
            }

            count++;
        }

        return count;
    }

    private static void ApplyRuntimeChanges(
        LEDBarLightVideoInput runtimeSupport)
    {
        UdonSharpEditorUtility.CopyProxyToUdon(runtimeSupport);
        EditorUtility.SetDirty(runtimeSupport);

        if (PrefabUtility.IsPartOfPrefabInstance(runtimeSupport))
        {
            PrefabUtility.RecordPrefabInstancePropertyModifications(
                runtimeSupport);
        }

        if (!Application.isPlaying &&
            runtimeSupport.gameObject.scene.IsValid() &&
            runtimeSupport.gameObject.scene.isLoaded)
        {
            EditorSceneManager.MarkSceneDirty(
                runtimeSupport.gameObject.scene);
        }
    }
}
#endif
