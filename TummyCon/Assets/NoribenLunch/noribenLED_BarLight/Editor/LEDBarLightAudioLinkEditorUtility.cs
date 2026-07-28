#if UNITY_EDITOR
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

internal static class LEDBarLightAudioLinkEditorUtility
{
    private const string AudioLinkTypeName = "AudioLink.AudioLink";
    private const string AudioLinkKeyword = "AudioLinkOn";
    private const string AudioLinkOnProperty = "_AudioLinkOn";
    private const string AudioLinkIntensityProperty = "_AudioLinkIntensity";
    private const string AudioLinkTypeProperty = "_AudioLinkType";

    private static readonly string[] JapaneseBandNames =
    {
        "Bass（低音）",
        "Low Mid（中低音）",
        "High Mid（中高音）",
        "Treble（高音）"
    };

    private static readonly string[] EnglishBandNames =
    {
        "Bass",
        "Low Mid",
        "High Mid",
        "Treble"
    };

    public static Material[] GetTargetMaterials(
        LEDBarLightVideoInput runtimeSupport)
    {
        if (runtimeSupport == null)
        {
            return new Material[0];
        }

        SerializedObject runtimeObject =
            new SerializedObject(runtimeSupport);
        runtimeObject.Update();
        return GetTargetMaterials(
            runtimeObject.FindProperty("TargetMaterials"));
    }

    public static Material[] GetTargetMaterials(
        SerializedProperty materialsProperty)
    {
        if (materialsProperty == null || !materialsProperty.isArray)
        {
            return new Material[0];
        }

        List<Material> materials = new List<Material>();
        for (int i = 0; i < materialsProperty.arraySize; i++)
        {
            Material material = materialsProperty
                .GetArrayElementAtIndex(i)
                .objectReferenceValue as Material;
            if (material != null && !materials.Contains(material))
            {
                materials.Add(material);
            }
        }

        return materials.ToArray();
    }

    public static void DrawSettings(
        Material[] materials,
        bool isJapanese)
    {
        EditorGUILayout.LabelField(
            "AudioLink",
            EditorStyles.boldLabel);
        EditorGUILayout.BeginVertical(EditorStyles.helpBox);

        if (!HasValidMaterials(materials))
        {
            EditorGUILayout.HelpBox(
                isJapanese
                    ? "AudioLinkを設定する対象マテリアルが見つかりません。"
                    : "No target materials were found for AudioLink settings.",
                MessageType.Error);
            EditorGUILayout.EndVertical();
            return;
        }

        bool audioLinkOn = IsAudioLinkEnabled(materials[0]);
        bool mixedOn = HasMixedEnabledValue(materials, audioLinkOn);
        EditorGUI.showMixedValue = mixedOn;
        EditorGUI.BeginChangeCheck();
        bool selectedOn = EditorGUILayout.Toggle(
            isJapanese ? "AudioLinkを使用" : "Enable AudioLink",
            audioLinkOn);
        if (EditorGUI.EndChangeCheck())
        {
            ApplyEnabled(materials, selectedOn, isJapanese);
            audioLinkOn = selectedOn;
            mixedOn = false;
        }
        EditorGUI.showMixedValue = false;

        using (new EditorGUI.DisabledScope(!audioLinkOn && !mixedOn))
        {
            float intensity = materials[0].GetFloat(
                AudioLinkIntensityProperty);
            bool mixedIntensity = HasMixedFloatValue(
                materials,
                AudioLinkIntensityProperty,
                intensity);
            EditorGUI.showMixedValue = mixedIntensity;
            EditorGUI.BeginChangeCheck();
            float selectedIntensity = EditorGUILayout.Slider(
                "AudioLink Intensity",
                intensity,
                0.0f,
                4.0f);
            if (EditorGUI.EndChangeCheck())
            {
                ApplyFloat(
                    materials,
                    AudioLinkIntensityProperty,
                    selectedIntensity,
                    isJapanese
                        ? "AudioLink Intensityを変更"
                        : "Change AudioLink Intensity");
            }
            EditorGUI.showMixedValue = false;

            int bandType = Mathf.Clamp(
                Mathf.RoundToInt(materials[0].GetFloat(
                    AudioLinkTypeProperty)),
                0,
                3);
            bool mixedBand = HasMixedFloatValue(
                materials,
                AudioLinkTypeProperty,
                bandType);
            EditorGUI.showMixedValue = mixedBand;
            EditorGUI.BeginChangeCheck();
            int selectedBand = EditorGUILayout.Popup(
                isJapanese ? "Band Type" : "Band Type",
                bandType,
                isJapanese ? JapaneseBandNames : EnglishBandNames);
            if (EditorGUI.EndChangeCheck())
            {
                ApplyFloat(
                    materials,
                    AudioLinkTypeProperty,
                    selectedBand,
                    isJapanese
                        ? "AudioLink Band Typeを変更"
                        : "Change AudioLink Band Type");
            }
            EditorGUI.showMixedValue = false;
        }

        EditorGUILayout.LabelField(
            isJapanese
                ? "AudioLinkが配置されている場合、選択した帯域の音量でバーライトが反応します。"
                : "When AudioLink is present, the bar lights react to the volume of the selected frequency band.",
            EditorStyles.wordWrappedMiniLabel);
        EditorGUILayout.EndVertical();
    }

    public static void DrawDiagnostic(
        Material[] materials,
        bool isJapanese)
    {
        EditorGUILayout.LabelField(
            "AudioLink",
            EditorStyles.boldLabel);

        if (!HasValidMaterials(materials))
        {
            DrawStatus(
                "✖",
                new Color(1.0f, 0.35f, 0.35f),
                isJapanese
                    ? "AudioLink：対象マテリアルなし"
                    : "AudioLink: No target materials");
            return;
        }

        bool audioLinkOn = AnyAudioLinkEnabled(materials);
        List<Component> audioLinks = FindAudioLinks();
        if (!audioLinkOn)
        {
            DrawStatus(
                "－",
                Color.gray,
                isJapanese
                    ? "AudioLink：未使用（任意）"
                    : "AudioLink: Disabled (optional)");
            return;
        }

        int activeCount = CountActiveAudioLinks(audioLinks);
        if (activeCount == 1)
        {
            DrawStatus(
                "✓",
                new Color(0.2f, 0.85f, 0.3f),
                isJapanese
                    ? "AudioLink：検出済み"
                    : "AudioLink: Found");
        }
        else if (activeCount == 0)
        {
            DrawStatus(
                "⚠",
                new Color(1.0f, 0.65f, 0.1f),
                audioLinks.Count > 0
                    ? (isJapanese
                        ? "AudioLink：配置されていますが無効です"
                        : "AudioLink: Found but inactive")
                    : (isJapanese
                        ? "AudioLink：未配置（音への反応は無効）"
                        : "AudioLink: Not found (audio reaction disabled)"));
            EditorGUILayout.HelpBox(
                isJapanese
                    ? "バーライトの表示とカラーサンプリングは動作しますが、音への反応は行われません。"
                    : "The bar lights and color sampling still work, but they will not react to audio.",
                MessageType.Warning);
        }
        else
        {
            DrawStatus(
                "⚠",
                new Color(1.0f, 0.65f, 0.1f),
                isJapanese
                    ? $"AudioLink：複数検出（{activeCount}個）"
                    : $"AudioLink: Multiple instances found ({activeCount})");
            EditorGUILayout.HelpBox(
                isJapanese
                    ? "通常、AudioLinkはシーンに1つだけ配置してください。"
                    : "Normally, keep only one AudioLink instance in the scene.",
                MessageType.Warning);
        }

    }

    private static bool HasValidMaterials(Material[] materials)
    {
        if (materials == null || materials.Length == 0)
        {
            return false;
        }

        for (int i = 0; i < materials.Length; i++)
        {
            Material material = materials[i];
            if (material == null ||
                !material.HasProperty(AudioLinkOnProperty) ||
                !material.HasProperty(AudioLinkIntensityProperty) ||
                !material.HasProperty(AudioLinkTypeProperty))
            {
                return false;
            }
        }

        return true;
    }

    private static bool IsAudioLinkEnabled(Material material)
    {
        return material.IsKeywordEnabled(AudioLinkKeyword) &&
               material.GetFloat(AudioLinkOnProperty) > 0.5f;
    }

    private static bool AnyAudioLinkEnabled(Material[] materials)
    {
        for (int i = 0; i < materials.Length; i++)
        {
            if (IsAudioLinkEnabled(materials[i]))
            {
                return true;
            }
        }
        return false;
    }

    private static bool HasMixedEnabledValue(
        Material[] materials,
        bool firstValue)
    {
        for (int i = 1; i < materials.Length; i++)
        {
            if (IsAudioLinkEnabled(materials[i]) != firstValue)
            {
                return true;
            }
        }
        return false;
    }

    private static bool HasMixedFloatValue(
        Material[] materials,
        string propertyName,
        float firstValue)
    {
        for (int i = 1; i < materials.Length; i++)
        {
            if (!Mathf.Approximately(
                    materials[i].GetFloat(propertyName),
                    firstValue))
            {
                return true;
            }
        }
        return false;
    }

    private static void ApplyEnabled(
        Material[] materials,
        bool enabled,
        bool isJapanese)
    {
        Undo.RecordObjects(
            materials,
            isJapanese
                ? "AudioLink設定を変更"
                : "Change AudioLink Settings");
        for (int i = 0; i < materials.Length; i++)
        {
            Material material = materials[i];
            material.SetFloat(AudioLinkOnProperty, enabled ? 1.0f : 0.0f);
            if (enabled)
            {
                material.EnableKeyword(AudioLinkKeyword);
            }
            else
            {
                material.DisableKeyword(AudioLinkKeyword);
            }
            EditorUtility.SetDirty(material);
        }
    }

    private static void ApplyFloat(
        Material[] materials,
        string propertyName,
        float value,
        string undoName)
    {
        Undo.RecordObjects(materials, undoName);
        for (int i = 0; i < materials.Length; i++)
        {
            materials[i].SetFloat(propertyName, value);
            EditorUtility.SetDirty(materials[i]);
        }
    }

    private static List<Component> FindAudioLinks()
    {
        MonoBehaviour[] behaviours = Object.FindObjectsByType<MonoBehaviour>(
            FindObjectsInactive.Include,
            FindObjectsSortMode.None);
        List<Component> audioLinks = new List<Component>();
        for (int i = 0; i < behaviours.Length; i++)
        {
            MonoBehaviour behaviour = behaviours[i];
            if (behaviour == null ||
                behaviour.GetType().FullName != AudioLinkTypeName ||
                !behaviour.gameObject.scene.IsValid() ||
                !behaviour.gameObject.scene.isLoaded)
            {
                continue;
            }
            audioLinks.Add(behaviour);
        }
        return audioLinks;
    }

    private static int CountActiveAudioLinks(List<Component> audioLinks)
    {
        int count = 0;
        for (int i = 0; i < audioLinks.Count; i++)
        {
            Behaviour behaviour = audioLinks[i] as Behaviour;
            if (audioLinks[i].gameObject.activeInHierarchy &&
                (behaviour == null || behaviour.enabled))
            {
                count++;
            }
        }
        return count;
    }

    private static void DrawStatus(
        string symbol,
        Color color,
        string text)
    {
        EditorGUILayout.BeginHorizontal();
        Color previousColor = GUI.contentColor;
        GUI.contentColor = color;
        EditorGUILayout.LabelField(symbol, GUILayout.Width(16.0f));
        GUI.contentColor = previousColor;
        EditorGUILayout.LabelField(text);
        EditorGUILayout.EndHorizontal();
    }
}
#endif
