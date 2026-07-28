#if UNITY_EDITOR
using System;
using System.Collections.Generic;
using UdonSharp;
using UdonSharpEditor;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;
using VRC.Udon;

internal static class LEDBarLightVideoInputEditorUtility
{
    private const string ReceiverName = "VideoInputReceiver";
    private const string ReceiverMaterialPath =
        "Assets/NoribenLunch/noribenLED_BarLight/Materials/LEDBarLightVideoInputReceiver.mat";
    private const string BarLightMaterialPath =
        "Assets/NoribenLunch/noribenLED_BarLight/Materials/LED_BarLight_LightShaft_BarLight10set_MovieColor.mat";
    private const string CenterMaterialPath =
        "Assets/NoribenLunch/noribenLED_BarLight/Materials/LED_BarLight_LightShaft_CenterCircle_MovieColor.mat";

    private const string IwaCoreType = "HoshinoLabs.IwaSync3.Udon.VideoCore";
    private const string IwaScreenType = "HoshinoLabs.IwaSync3.Udon.VideoScreen";
    private const string VizVidCoreType = "JLChnToZ.VRC.VVMW.Core";
    private const string VizVidScreenConfiguratorType =
        "JLChnToZ.VRC.VVMW.Designer.ScreenConfigurator";
    private const string YamaControllerType = "Yamadev.YamaStream.Controller";
    private const string YamaScreenType = "Yamadev.YamaStream.YamaPlayerScreen";
    private const string ProTvManagerType = "ArchiTech.ProTV.TVManager";

    private enum Provider
    {
        IwaSync,
        VizVid,
        YamaPlayer,
        ProTV
    }

    private sealed class Candidate
    {
        public Component Component;
        public Provider Provider;
        public string DisplayName;
    }

    private static bool showManualSettings;

    public static void Draw(
        LEDBarLightVideoInput videoInput,
        Transform systemRoot,
        bool isJapanese)
    {
        EditorGUILayout.LabelField(
            isJapanese
                ? "対応：iwaSync / ProTV 3.0 / VizVid / YamaPlayer"
                : "Supported: iwaSync / ProTV 3.0 / VizVid / YamaPlayer",
            EditorStyles.wordWrappedMiniLabel);

        if (videoInput == null)
        {
            EditorGUILayout.HelpBox(
                isJapanese
                    ? "動画入力コンポーネントが見つかりません。完成済みPrefabを配置し直してください。"
                    : "The video input component was not found. Re-place the finished prefab.",
                MessageType.Error);
            return;
        }

        SerializedObject inputObject = new SerializedObject(videoInput);
        inputObject.Update();
        SerializedProperty enabledProperty =
            inputObject.FindProperty("VideoInputEnabled");
        SerializedProperty providerProperty =
            inputObject.FindProperty("VideoInputProviderName");
        SerializedProperty playerRootProperty =
            inputObject.FindProperty("VideoInputPlayerRoot");
        SerializedProperty directTextureProperty =
            inputObject.FindProperty("VideoInputDirectTexture");
        SerializedProperty targetMaterialsProperty =
            inputObject.FindProperty("TargetMaterials");

        bool connected = enabledProperty.boolValue;
        string providerName = providerProperty.stringValue;
        GameObject playerRoot =
            playerRootProperty.objectReferenceValue as GameObject;

        DrawStatus(
            connected,
            connected
                ? (isJapanese
                    ? "接続済み：" + providerName
                    : "Connected: " + providerName)
                : (isJapanese
                    ? "動画入力は未設定です"
                    : "Video input is not configured"));

        if (connected && playerRoot != null)
        {
            EditorGUILayout.LabelField(
                isJapanese ? "接続先" : "Source",
                GetHierarchyPath(playerRoot.transform));
        }

        int validMaterialCount = CountValidTargetMaterials(targetMaterialsProperty);
        if (validMaterialCount == 2)
        {
            EditorGUILayout.LabelField(
                isJapanese
                    ? "✓ MovieColorマテリアル：2個"
                    : "✓ MovieColor materials: 2",
                EditorStyles.miniLabel);
        }
        else
        {
            EditorGUILayout.HelpBox(
                isJapanese
                    ? "MovieColorマテリアル参照が不足しています。自動設定時に修復されます。"
                    : "MovieColor material references are incomplete. Auto setup will repair them.",
                MessageType.Warning);
        }

        using (new EditorGUI.DisabledScope(Application.isPlaying))
        {
            EditorGUILayout.BeginHorizontal();
            if (GUILayout.Button(
                    connected
                        ? (isJapanese ? "接続先を変更" : "Change Connection")
                        : (isJapanese
                            ? "動画プレイヤーを自動検出・設定"
                            : "Auto Detect and Configure Video Player")))
            {
                AutoDetectAndConnect(videoInput, systemRoot, isJapanese);
                GUIUtility.ExitGUI();
            }

            if (connected && GUILayout.Button(
                    isJapanese ? "接続解除" : "Disconnect",
                    GUILayout.Width(90f)))
            {
                Disconnect(videoInput, true);
                GUIUtility.ExitGUI();
            }
            EditorGUILayout.EndHorizontal();

            showManualSettings = EditorGUILayout.Foldout(
                showManualSettings,
                isJapanese ? "詳細設定" : "Advanced Setup",
                true);
            if (showManualSettings)
            {
                EditorGUI.indentLevel++;
                EditorGUI.BeginChangeCheck();
                EditorGUILayout.PropertyField(
                    playerRootProperty,
                    new GUIContent(
                        isJapanese
                            ? "動画プレイヤーのルート"
                            : "Video Player Root"));
                if (EditorGUI.EndChangeCheck())
                {
                    inputObject.ApplyModifiedProperties();
                    ApplyVideoInputChanges(videoInput);
                    inputObject.Update();
                }

                GameObject manualRoot =
                    playerRootProperty.objectReferenceValue as GameObject;
                using (new EditorGUI.DisabledScope(manualRoot == null))
                {
                    if (GUILayout.Button(
                            isJapanese
                                ? "指定したプレイヤーに接続"
                                : "Connect Selected Player"))
                    {
                        List<Candidate> candidates = FindCandidates(
                            systemRoot.gameObject.scene,
                            manualRoot);
                        PresentCandidates(
                            videoInput,
                            systemRoot,
                            candidates,
                            isJapanese);
                        GUIUtility.ExitGUI();
                    }
                }

                EditorGUILayout.Space(3f);
                EditorGUILayout.PropertyField(
                    directTextureProperty,
                    new GUIContent(
                        isJapanese
                            ? "RenderTexture／Texture"
                            : "RenderTexture / Texture"));
                if (inputObject.ApplyModifiedProperties())
                {
                    ApplyVideoInputChanges(videoInput);
                    inputObject.Update();
                }

                Texture directTexture =
                    directTextureProperty.objectReferenceValue as Texture;
                using (new EditorGUI.DisabledScope(directTexture == null))
                {
                    if (GUILayout.Button(
                            isJapanese
                                ? "指定Textureを使用"
                                : "Use Selected Texture"))
                    {
                        ConnectDirectTexture(
                            videoInput,
                            systemRoot,
                            directTexture,
                            isJapanese);
                        GUIUtility.ExitGUI();
                    }
                }
                EditorGUI.indentLevel--;
            }
        }

        if (Application.isPlaying)
        {
            EditorGUILayout.LabelField(
                isJapanese
                    ? "接続変更はEdit Modeで行ってください。"
                    : "Change the connection in Edit Mode.",
                EditorStyles.wordWrappedMiniLabel);
        }
    }

    private static void AutoDetectAndConnect(
        LEDBarLightVideoInput videoInput,
        Transform systemRoot,
        bool isJapanese)
    {
        List<Candidate> candidates = FindCandidates(
            systemRoot.gameObject.scene,
            null);
        PresentCandidates(videoInput, systemRoot, candidates, isJapanese);
    }

    private static void PresentCandidates(
        LEDBarLightVideoInput videoInput,
        Transform systemRoot,
        List<Candidate> candidates,
        bool isJapanese)
    {
        if (candidates.Count == 0)
        {
            EditorUtility.DisplayDialog(
                isJapanese ? "動画プレイヤー未検出" : "No Video Player Found",
                isJapanese
                    ? "iwaSync、ProTV 3.0、VizVid、YamaPlayerのいずれかがシーンに配置されていることを確認してください。"
                    : "Make sure iwaSync, ProTV 3.0, VizVid, or YamaPlayer is placed in the scene.",
                "OK");
            return;
        }

        if (candidates.Count == 1)
        {
            Connect(videoInput, systemRoot, candidates[0], isJapanese);
            return;
        }

        GenericMenu menu = new GenericMenu();
        for (int i = 0; i < candidates.Count; i++)
        {
            Candidate candidate = candidates[i];
            string label = candidate.DisplayName + " — " +
                           GetHierarchyPath(candidate.Component.transform);
            menu.AddItem(
                new GUIContent(label),
                false,
                () => Connect(
                    videoInput,
                    systemRoot,
                    candidate,
                    isJapanese));
        }
        menu.ShowAsContext();
    }

    private static List<Candidate> FindCandidates(
        Scene scene,
        GameObject searchRoot)
    {
        List<Candidate> result = new List<Candidate>();
        MonoBehaviour[] behaviours = Resources.FindObjectsOfTypeAll<MonoBehaviour>();

        for (int i = 0; i < behaviours.Length; i++)
        {
            MonoBehaviour behaviour = behaviours[i];
            if (behaviour == null ||
                EditorUtility.IsPersistent(behaviour) ||
                !behaviour.gameObject.scene.IsValid() ||
                behaviour.gameObject.scene != scene)
            {
                continue;
            }

            if (searchRoot != null &&
                behaviour.transform != searchRoot.transform &&
                !behaviour.transform.IsChildOf(searchRoot.transform))
            {
                continue;
            }

            string fullName = behaviour.GetType().FullName;
            Candidate candidate = null;
            if (fullName == IwaCoreType)
            {
                candidate = NewCandidate(behaviour, Provider.IwaSync, "iwaSync");
            }
            else if (fullName == VizVidCoreType)
            {
                candidate = NewCandidate(behaviour, Provider.VizVid, "VizVid");
            }
            else if (fullName == YamaControllerType)
            {
                candidate = NewCandidate(behaviour, Provider.YamaPlayer, "YamaPlayer");
            }
            else if (fullName == ProTvManagerType)
            {
                candidate = NewCandidate(behaviour, Provider.ProTV, "ProTV");
            }

            if (candidate != null)
            {
                result.Add(candidate);
            }
        }

        result.Sort((a, b) => string.CompareOrdinal(
            GetHierarchyPath(a.Component.transform),
            GetHierarchyPath(b.Component.transform)));
        return result;
    }

    private static Candidate NewCandidate(
        Component component,
        Provider provider,
        string displayName)
    {
        return new Candidate
        {
            Component = component,
            Provider = provider,
            DisplayName = displayName
        };
    }

    private static void Connect(
        LEDBarLightVideoInput videoInput,
        Transform systemRoot,
        Candidate candidate,
        bool isJapanese)
    {
        Disconnect(videoInput, false);
        AssignDefaultTargetMaterials(videoInput);

        Renderer receiver = null;
        UdonBehaviour sourceBehaviour = null;
        string sourceVariable = "";
        int sourceMode;
        bool configured;

        if (candidate.Provider == Provider.ProTV)
        {
            sourceMode = 2;
            sourceVariable = "_internalTexture";
            sourceBehaviour = GetBackingUdonBehaviour(candidate.Component);
            configured = sourceBehaviour != null;
        }
        else
        {
            sourceMode = 1;
            receiver = GetOrCreateReceiver(systemRoot);
            if (receiver != null)
            {
                receiver.gameObject.SetActive(true);
            }
            configured = receiver != null && ConfigureReceiver(candidate, receiver);
        }

        if (!configured)
        {
            if (receiver != null)
            {
                RemoveReceiverProviderComponents(receiver);
                receiver.gameObject.SetActive(false);
            }

            EditorUtility.DisplayDialog(
                isJapanese ? "接続失敗" : "Connection Failed",
                isJapanese
                    ? candidate.DisplayName + "への接続に失敗しました。対応バージョンとコンポーネント構成を確認してください。"
                    : "Failed to connect to " + candidate.DisplayName + ". Check its version and component setup.",
                "OK");
            return;
        }

        ApplyConnection(
            videoInput,
            sourceMode,
            candidate.Component.gameObject,
            candidate.DisplayName,
            receiver,
            sourceBehaviour,
            sourceVariable,
            null);
    }

    private static void ConnectDirectTexture(
        LEDBarLightVideoInput videoInput,
        Transform systemRoot,
        Texture texture,
        bool isJapanese)
    {
        if (texture == null)
        {
            return;
        }

        Disconnect(videoInput, false);
        AssignDefaultTargetMaterials(videoInput);
        ApplyConnection(
            videoInput,
            3,
            null,
            isJapanese ? "指定Texture" : "Assigned Texture",
            null,
            null,
            "",
            texture);
    }

    private static Renderer GetOrCreateReceiver(Transform systemRoot)
    {
        Transform existing = FindDeepChild(systemRoot, ReceiverName);
        if (existing != null)
        {
            MeshRenderer existingRenderer = existing.GetComponent<MeshRenderer>();
            if (existingRenderer == null)
            {
                existingRenderer = Undo.AddComponent<MeshRenderer>(existing.gameObject);
            }
            ConfigureReceiverRenderer(existingRenderer, systemRoot.gameObject.layer);
            return existingRenderer;
        }

        GameObject receiverObject = new GameObject(ReceiverName);
        Undo.RegisterCreatedObjectUndo(
            receiverObject,
            "Create LED BarLight Video Input Receiver");
        receiverObject.transform.SetParent(systemRoot, false);
        MeshRenderer receiver = Undo.AddComponent<MeshRenderer>(receiverObject);
        ConfigureReceiverRenderer(receiver, systemRoot.gameObject.layer);
        return receiver;
    }

    private static void ConfigureReceiverRenderer(
        MeshRenderer receiver,
        int layer)
    {
        receiver.gameObject.layer = layer;
        receiver.shadowCastingMode = ShadowCastingMode.Off;
        receiver.receiveShadows = false;
        receiver.lightProbeUsage = LightProbeUsage.Off;
        receiver.reflectionProbeUsage = ReflectionProbeUsage.Off;
        receiver.motionVectorGenerationMode = MotionVectorGenerationMode.ForceNoMotion;
        receiver.allowOcclusionWhenDynamic = false;
        receiver.sharedMaterial = AssetDatabase.LoadAssetAtPath<Material>(
            ReceiverMaterialPath);
        receiver.enabled = true;
    }

    private static bool ConfigureReceiver(Candidate candidate, Renderer receiver)
    {
        if (candidate.Provider == Provider.IwaSync)
        {
            return ConfigureIwaSync(candidate.Component, receiver);
        }
        if (candidate.Provider == Provider.VizVid)
        {
            return ConfigureVizVid(candidate.Component, receiver);
        }
        if (candidate.Provider == Provider.YamaPlayer)
        {
            return ConfigureYamaPlayer(candidate.Component, receiver);
        }
        return false;
    }

    private static bool ConfigureIwaSync(Component core, Renderer receiver)
    {
        Type screenType = core.GetType().Assembly.GetType(IwaScreenType);
        if (screenType == null ||
            !typeof(UdonSharpBehaviour).IsAssignableFrom(screenType))
        {
            return false;
        }

        UdonSharpBehaviour screen = UdonSharpUndo.AddComponent(
            receiver.gameObject,
            screenType);
        SerializedObject screenObject = new SerializedObject(screen);
        screenObject.Update();
        if (!SetObject(screenObject, "core", core) ||
            !SetObject(screenObject, "screen", receiver) ||
            !SetString(screenObject, "textureProperty", "_MainTex"))
        {
            UdonSharpUndo.DestroyImmediate(screen);
            return false;
        }
        SetInteger(screenObject, "materialIndex", 0);
        SetBoolean(screenObject, "idleScreenOff", false);
        SetBoolean(screenObject, "defaultMirror", false);
        screenObject.ApplyModifiedProperties();
        UdonSharpEditorUtility.CopyProxyToUdon(screen);
        EditorUtility.SetDirty(screen);
        return true;
    }

    private static bool ConfigureYamaPlayer(Component controller, Renderer receiver)
    {
        Type screenType = controller.GetType().Assembly.GetType(YamaScreenType);
        if (screenType == null ||
            !typeof(UdonSharpBehaviour).IsAssignableFrom(screenType))
        {
            return false;
        }

        UdonSharpBehaviour screen = UdonSharpUndo.AddComponent(
            receiver.gameObject,
            screenType);
        SerializedObject screenObject = new SerializedObject(screen);
        screenObject.Update();
        if (!SetObject(screenObject, "_controller", controller))
        {
            UdonSharpUndo.DestroyImmediate(screen);
            return false;
        }
        screenObject.ApplyModifiedProperties();
        UdonSharpEditorUtility.CopyProxyToUdon(screen);
        EditorUtility.SetDirty(screen);
        return true;
    }

    private static bool ConfigureVizVid(Component core, Renderer receiver)
    {
        Type configuratorType = core.GetType().Assembly.GetType(
            VizVidScreenConfiguratorType);
        if (configuratorType == null ||
            !typeof(MonoBehaviour).IsAssignableFrom(configuratorType))
        {
            return false;
        }

        Component configurator = receiver.GetComponent(configuratorType);
        if (configurator == null)
        {
            configurator = Undo.AddComponent(
                receiver.gameObject,
                configuratorType);
        }

        SerializedObject configuratorObject = new SerializedObject(configurator);
        configuratorObject.Update();
        bool valid =
            SetObject(configuratorObject, "core", core) &&
            SetObject(configuratorObject, "screenRenderer", receiver) &&
            SetInteger(configuratorObject, "targetMode", 1) &&
            SetInteger(configuratorObject, "targetIndex", 0) &&
            SetString(configuratorObject, "targetPropertyName", "_MainTex") &&
            SetString(configuratorObject, "avProPropertyName", "_IsAVProVideo");
        SetObject(configuratorObject, "defaultTexture", null);
        configuratorObject.ApplyModifiedProperties();
        EditorUtility.SetDirty(configurator);
        PrefabUtility.RecordPrefabInstancePropertyModifications(configurator);
        return valid;
    }

    private static UdonBehaviour GetBackingUdonBehaviour(Component component)
    {
        UdonSharpBehaviour proxy = component as UdonSharpBehaviour;
        return proxy == null
            ? null
            : UdonSharpEditorUtility.GetBackingUdonBehaviour(proxy);
    }

    private static void ApplyConnection(
        LEDBarLightVideoInput videoInput,
        int sourceMode,
        GameObject playerRoot,
        string providerName,
        Renderer receiver,
        UdonBehaviour sourceBehaviour,
        string sourceVariable,
        Texture directTexture)
    {
        Undo.RecordObject(videoInput, "Connect LED BarLight Video Input");
        SerializedObject inputObject = new SerializedObject(videoInput);
        inputObject.Update();
        SetBoolean(inputObject, "VideoInputEnabled", true);
        SetInteger(inputObject, "VideoInputSourceMode", sourceMode);
        SetObject(inputObject, "VideoInputPlayerRoot", playerRoot);
        SetString(inputObject, "VideoInputProviderName", providerName);
        SetObject(inputObject, "VideoInputReceiverRenderer", receiver);
        SetObject(inputObject, "VideoInputSourceBehaviour", sourceBehaviour);
        SetString(inputObject, "VideoInputSourceVariable", sourceVariable);
        SetObject(inputObject, "VideoInputDirectTexture", directTexture);
        inputObject.ApplyModifiedProperties();
        ApplyVideoInputChanges(videoInput);
    }

    private static void Disconnect(
        LEDBarLightVideoInput videoInput,
        bool logResult)
    {
        SerializedObject inputObject = new SerializedObject(videoInput);
        inputObject.Update();
        SerializedProperty receiverProperty =
            inputObject.FindProperty("VideoInputReceiverRenderer");
        Renderer receiver =
            receiverProperty.objectReferenceValue as Renderer;

        Transform configuredReceiver = FindDeepChild(
            videoInput.transform,
            ReceiverName);
        if (configuredReceiver != null)
        {
            Renderer rendererOnRoot = configuredReceiver.GetComponent<Renderer>();
            if (rendererOnRoot != null)
            {
                receiver = rendererOnRoot;
            }
        }

        CleanupReceiver(receiver, videoInput.gameObject.scene);

        Undo.RecordObject(videoInput, "Disconnect LED BarLight Video Input");
        SetBoolean(inputObject, "VideoInputEnabled", false);
        SetInteger(inputObject, "VideoInputSourceMode", 0);
        SetObject(inputObject, "VideoInputPlayerRoot", null);
        SetString(inputObject, "VideoInputProviderName", "");
        SetObject(inputObject, "VideoInputReceiverRenderer", receiver);
        SetObject(inputObject, "VideoInputSourceBehaviour", null);
        SetString(inputObject, "VideoInputSourceVariable", "");
        SetObject(inputObject, "VideoInputDirectTexture", null);
        inputObject.ApplyModifiedProperties();
        ApplyVideoInputChanges(videoInput);

        if (logResult)
        {
            Debug.Log(
                "[LED BarLight System] Disconnected video input.",
                videoInput);
        }
    }

    private static void RemoveVizVidReceiverReferences(
        Renderer receiver,
        Scene scene)
    {
        if (receiver == null)
        {
            return;
        }

        MonoBehaviour[] behaviours = Resources.FindObjectsOfTypeAll<MonoBehaviour>();
        for (int i = 0; i < behaviours.Length; i++)
        {
            MonoBehaviour behaviour = behaviours[i];
            if (behaviour == null ||
                behaviour.GetType().FullName != VizVidCoreType ||
                behaviour.gameObject.scene != scene)
            {
                continue;
            }

            SerializedObject coreObject = new SerializedObject(behaviour);
            coreObject.Update();
            SerializedProperty targets = coreObject.FindProperty("screenTargets");
            if (targets == null || !targets.isArray)
            {
                continue;
            }

            for (int index = targets.arraySize - 1; index >= 0; index--)
            {
                if (targets.GetArrayElementAtIndex(index).objectReferenceValue != receiver)
                {
                    continue;
                }

                Undo.RecordObject(behaviour, "Remove LED BarLight Video Input");
                RemoveArrayElement(coreObject.FindProperty("screenTargets"), index);
                RemoveArrayElement(coreObject.FindProperty("screenTargetModes"), index);
                RemoveArrayElement(coreObject.FindProperty("screenTargetIndeces"), index);
                RemoveArrayElement(coreObject.FindProperty("screenTargetPropertyNames"), index);
                RemoveArrayElement(coreObject.FindProperty("avProPropertyNames"), index);
                RemoveArrayElement(coreObject.FindProperty("screenTargetDefaultTextures"), index);
                RemoveArrayElement(coreObject.FindProperty("rtScreenTargetSTs"), index);
            }

            if (coreObject.ApplyModifiedProperties())
            {
                UdonSharpBehaviour proxy = behaviour as UdonSharpBehaviour;
                if (proxy != null)
                {
                    UdonSharpEditorUtility.CopyProxyToUdon(proxy);
                }
                EditorUtility.SetDirty(behaviour);
                PrefabUtility.RecordPrefabInstancePropertyModifications(behaviour);
            }
        }
    }

    private static void RemoveReceiverProviderComponents(Renderer receiver)
    {
        Component[] components = receiver.GetComponents<Component>();
        for (int i = components.Length - 1; i >= 0; i--)
        {
            Component component = components[i];
            if (component == null ||
                component is Transform ||
                component is MeshRenderer)
            {
                continue;
            }

            string fullName = component.GetType().FullName;
            if (fullName == IwaScreenType || fullName == YamaScreenType)
            {
                UdonSharpBehaviour udonSharpComponent =
                    component as UdonSharpBehaviour;
                if (udonSharpComponent != null)
                {
                    UdonSharpUndo.DestroyImmediate(udonSharpComponent);
                }
            }
            else if (fullName == VizVidScreenConfiguratorType)
            {
                Undo.DestroyObjectImmediate(component);
            }
        }
    }

    private static void CleanupReceiver(Renderer receiver, Scene scene)
    {
        if (receiver == null)
        {
            return;
        }

        RemoveVizVidReceiverReferences(receiver, scene);
        RemoveReceiverProviderComponents(receiver);
        Undo.RecordObject(
            receiver.gameObject,
            "Disable LED BarLight Video Input Receiver");
        receiver.gameObject.SetActive(false);
    }

    private static void AssignDefaultTargetMaterials(
        LEDBarLightVideoInput videoInput)
    {
        Material barLightMaterial = AssetDatabase.LoadAssetAtPath<Material>(
            BarLightMaterialPath);
        Material centerMaterial = AssetDatabase.LoadAssetAtPath<Material>(
            CenterMaterialPath);

        Undo.RecordObject(videoInput, "Assign LED BarLight Movie Materials");
        SerializedObject inputObject = new SerializedObject(videoInput);
        inputObject.Update();
        SerializedProperty materials = inputObject.FindProperty("TargetMaterials");
        materials.arraySize = 2;
        materials.GetArrayElementAtIndex(0).objectReferenceValue =
            barLightMaterial;
        materials.GetArrayElementAtIndex(1).objectReferenceValue =
            centerMaterial;
        inputObject.ApplyModifiedProperties();
        ApplyVideoInputChanges(videoInput);
    }

    private static int CountValidTargetMaterials(SerializedProperty materials)
    {
        if (materials == null || !materials.isArray)
        {
            return 0;
        }

        int count = 0;
        for (int i = 0; i < materials.arraySize; i++)
        {
            Material material =
                materials.GetArrayElementAtIndex(i).objectReferenceValue as Material;
            if (material != null && material.HasProperty("_MovieTex"))
            {
                count++;
            }
        }
        return count;
    }

    private static Transform FindDeepChild(Transform parent, string childName)
    {
        Transform[] transforms = parent.GetComponentsInChildren<Transform>(true);
        for (int i = 0; i < transforms.Length; i++)
        {
            if (transforms[i].name == childName)
            {
                return transforms[i];
            }
        }
        return null;
    }

    private static void RemoveArrayElement(
        SerializedProperty array,
        int index)
    {
        if (array == null ||
            !array.isArray ||
            index < 0 ||
            index >= array.arraySize)
        {
            return;
        }

        int previousSize = array.arraySize;
        array.DeleteArrayElementAtIndex(index);
        if (array.arraySize == previousSize)
        {
            array.DeleteArrayElementAtIndex(index);
        }
    }

    private static void ApplyVideoInputChanges(
        LEDBarLightVideoInput videoInput)
    {
        UdonSharpEditorUtility.CopyProxyToUdon(videoInput);
        EditorUtility.SetDirty(videoInput);
        PrefabUtility.RecordPrefabInstancePropertyModifications(videoInput);

        if (!Application.isPlaying && videoInput.gameObject.scene.IsValid())
        {
            EditorSceneManager.MarkSceneDirty(videoInput.gameObject.scene);
        }
    }

    private static bool SetObject(
        SerializedObject serializedObject,
        string propertyName,
        UnityEngine.Object value)
    {
        SerializedProperty property = serializedObject.FindProperty(propertyName);
        if (property == null)
        {
            return false;
        }
        property.objectReferenceValue = value;
        return true;
    }

    private static bool SetString(
        SerializedObject serializedObject,
        string propertyName,
        string value)
    {
        SerializedProperty property = serializedObject.FindProperty(propertyName);
        if (property == null)
        {
            return false;
        }
        property.stringValue = value;
        return true;
    }

    private static bool SetInteger(
        SerializedObject serializedObject,
        string propertyName,
        int value)
    {
        SerializedProperty property = serializedObject.FindProperty(propertyName);
        if (property == null)
        {
            return false;
        }
        property.intValue = value;
        return true;
    }

    private static bool SetBoolean(
        SerializedObject serializedObject,
        string propertyName,
        bool value)
    {
        SerializedProperty property = serializedObject.FindProperty(propertyName);
        if (property == null)
        {
            return false;
        }
        property.boolValue = value;
        return true;
    }

    private static void DrawStatus(bool ready, string text)
    {
        Color previousColor = GUI.color;
        GUI.color = ready
            ? new Color(0.75f, 1.0f, 0.75f)
            : new Color(1.0f, 0.92f, 0.65f);
        EditorGUILayout.BeginVertical(EditorStyles.helpBox);
        GUI.color = previousColor;
        EditorGUILayout.BeginHorizontal();
        if (ready)
        {
            Color previousContentColor = GUI.contentColor;
            GUI.contentColor = new Color(0.2f, 0.85f, 0.3f);
            EditorGUILayout.LabelField("✓", GUILayout.Width(16.0f));
            GUI.contentColor = previousContentColor;
        }
        else
        {
            EditorGUILayout.LabelField("○", GUILayout.Width(16.0f));
        }
        EditorGUILayout.LabelField(text);
        EditorGUILayout.EndHorizontal();
        EditorGUILayout.EndVertical();
    }

    private static string GetHierarchyPath(Transform transform)
    {
        if (transform == null)
        {
            return "";
        }

        string path = transform.name;
        Transform parent = transform.parent;
        while (parent != null)
        {
            path = parent.name + "/" + path;
            parent = parent.parent;
        }
        return path;
    }
}
#endif
