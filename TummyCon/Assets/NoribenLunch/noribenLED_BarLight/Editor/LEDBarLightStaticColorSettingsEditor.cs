#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;

[CustomEditor(typeof(LEDBarLightStaticColorSettings))]
public class LEDBarLightStaticColorSettingsEditor : Editor
{
    private enum InspectorLanguage
    {
        Japanese,
        English
    }

    private const string LanguagePrefKey =
        "Noriben.LEDBarLightSystem.InspectorLanguage";
    private const string SampleTextureProperty = "_SampleTex";
    private const string SampleToggleProperty = "_SampleTexOn";
    private const string SampleKeyword = "SampleTexToggle";

    private static readonly string[] LanguageNames =
    {
        "Japanese",
        "English"
    };

    private GUIStyle titleStyle;

    private InspectorLanguage Language
    {
        get => (InspectorLanguage)EditorPrefs.GetInt(
            LanguagePrefKey,
            (int)InspectorLanguage.Japanese);
        set => EditorPrefs.SetInt(LanguagePrefKey, (int)value);
    }

    private bool IsJapanese =>
        Language == InspectorLanguage.Japanese;

    public override VisualElement CreateInspectorGUI()
    {
        VisualElement root = new VisualElement();
        IMGUIContainer inspectorGUI = new IMGUIContainer(DrawInspectorGUI);
        root.Add(inspectorGUI);
        return root;
    }

    public override void OnInspectorGUI()
    {
        DrawInspectorGUI();
    }

    private void DrawInspectorGUI()
    {
        serializedObject.Update();
        DrawMainHeader();

        LEDBarLightStaticColorSettings settings =
            (LEDBarLightStaticColorSettings)target;
        LEDBarLightVideoInput runtimeSupport =
            settings.GetComponent<LEDBarLightVideoInput>();

        SerializedProperty runtimeProperty =
            serializedObject.FindProperty("RuntimeSupport");
        if (runtimeProperty.objectReferenceValue != runtimeSupport)
        {
            runtimeProperty.objectReferenceValue = runtimeSupport;
        }

        Material[] targetMaterials =
            LEDBarLightAudioLinkEditorUtility.GetTargetMaterials(
                serializedObject.FindProperty("TargetMaterials"));

        DrawTextureSettings();

        EditorGUILayout.Space(8f);
        LEDBarLightAudioLinkEditorUtility.DrawSettings(
            targetMaterials,
            IsJapanese);

        EditorGUILayout.Space(8f);
        LEDBarLightDepthEditorUtility.Draw(
            runtimeSupport,
            targetMaterials,
            IsJapanese);

        serializedObject.ApplyModifiedProperties();
    }

    private void DrawTextureSettings()
    {
        EditorGUILayout.LabelField(
            IsJapanese ? "カラーサンプリング" : "Color Sampling",
            EditorStyles.boldLabel);
        EditorGUILayout.BeginVertical(EditorStyles.helpBox);

        EditorGUILayout.LabelField(
            IsJapanese
                ? "このテクスチャを変更することで、バーライトの配色を変更できます。"
                : "Change this texture to change the color scheme of the bar lights.",
            EditorStyles.wordWrappedMiniLabel);
        EditorGUILayout.Space(3f);

        SerializedProperty textureProperty =
            serializedObject.FindProperty("SampleTexture");
        SerializedProperty materialsProperty =
            serializedObject.FindProperty("TargetMaterials");
        Material[] materials = GetTargetMaterials(materialsProperty);

        EditorGUI.BeginChangeCheck();
        Texture selectedTexture = (Texture)EditorGUILayout.ObjectField(
            IsJapanese ? "サンプリングテクスチャ" : "Sampling Texture",
            textureProperty.objectReferenceValue,
            typeof(Texture),
            false);
        if (EditorGUI.EndChangeCheck())
        {
            textureProperty.objectReferenceValue = selectedTexture;
            serializedObject.ApplyModifiedProperties();
            ApplySampleTexture(materials, selectedTexture);
            serializedObject.Update();
        }

        if (materials.Length == 0)
        {
            LEDBarLightDepthEditorUtility.DrawStatusLine(
                false,
                IsJapanese
                    ? "対象マテリアルが設定されていません"
                    : "Target materials are not configured");
            EditorGUILayout.HelpBox(
                IsJapanese
                    ? "StaticColor用マテリアル参照がありません。Prefabの内部設定を確認してください。"
                    : "StaticColor material references are missing. Check the prefab's internal setup.",
                MessageType.Error);
        }
        else
        {
            Texture texture = textureProperty.objectReferenceValue as Texture;
            bool applied = AreMaterialsUsingTexture(materials, texture);
            LEDBarLightDepthEditorUtility.DrawStatusLine(
                applied,
                applied
                    ? (IsJapanese
                        ? $"{materials.Length}個のマテリアルに適用済み"
                        : $"Applied to {materials.Length} material(s)")
                    : (IsJapanese
                        ? "マテリアルのTexture設定が一致していません"
                        : "Material texture settings do not match"));

            if (texture == null)
            {
                EditorGUILayout.HelpBox(
                    IsJapanese
                        ? "サンプリングするTextureを指定してください。"
                        : "Assign a texture to sample.",
                    MessageType.Warning);
            }
            else if (!applied &&
                     GUILayout.Button(
                         IsJapanese
                             ? "Texture設定を適用"
                             : "Apply Texture Settings",
                         GUILayout.Height(24f)))
            {
                ApplySampleTexture(materials, texture);
            }
        }

        EditorGUILayout.LabelField(
            IsJapanese
                ? "指定したTextureは、すべてのバーライトと中央リングの色サンプリングに使用されます。"
                : "The selected texture is sampled by every bar light and the center ring.",
            EditorStyles.wordWrappedMiniLabel);
        EditorGUILayout.EndVertical();
    }

    private static Material[] GetTargetMaterials(
        SerializedProperty materialsProperty)
    {
        if (materialsProperty == null || !materialsProperty.isArray)
        {
            return new Material[0];
        }

        Material[] materials =
            new Material[materialsProperty.arraySize];
        int count = 0;
        for (int i = 0; i < materialsProperty.arraySize; i++)
        {
            Material material = materialsProperty
                .GetArrayElementAtIndex(i)
                .objectReferenceValue as Material;
            if (material == null)
            {
                continue;
            }

            materials[count] = material;
            count++;
        }

        if (count == materials.Length)
        {
            return materials;
        }

        Material[] compactMaterials = new Material[count];
        for (int i = 0; i < count; i++)
        {
            compactMaterials[i] = materials[i];
        }
        return compactMaterials;
    }

    private static bool AreMaterialsUsingTexture(
        Material[] materials,
        Texture texture)
    {
        for (int i = 0; i < materials.Length; i++)
        {
            Material material = materials[i];
            if (!material.HasProperty(SampleTextureProperty) ||
                material.GetTexture(SampleTextureProperty) != texture ||
                !material.IsKeywordEnabled(SampleKeyword))
            {
                return false;
            }
        }

        return true;
    }

    private void ApplySampleTexture(
        Material[] materials,
        Texture texture)
    {
        Undo.RecordObjects(
            materials,
            IsJapanese
                ? "バーライトのサンプリングTextureを変更"
                : "Change BarLight Sampling Texture");

        for (int i = 0; i < materials.Length; i++)
        {
            Material material = materials[i];
            if (material == null ||
                !material.HasProperty(SampleTextureProperty))
            {
                continue;
            }

            material.SetTexture(SampleTextureProperty, texture);
            if (material.HasProperty(SampleToggleProperty))
            {
                material.SetFloat(SampleToggleProperty, 1.0f);
            }
            material.EnableKeyword(SampleKeyword);
            EditorUtility.SetDirty(material);
        }
    }

    private void DrawMainHeader()
    {
        if (titleStyle == null)
        {
            titleStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 17,
                alignment = TextAnchor.MiddleLeft
            };
        }

        EditorGUILayout.BeginVertical(EditorStyles.helpBox);
        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField(
            "LED BarLight System - Static Color",
            titleStyle);
        GUILayout.FlexibleSpace();
        InspectorLanguage selected =
            (InspectorLanguage)EditorGUILayout.Popup(
                (int)Language,
                LanguageNames,
                GUILayout.Width(90f));
        if (selected != Language)
        {
            Language = selected;
        }
        EditorGUILayout.EndHorizontal();
        EditorGUILayout.EndVertical();
        EditorGUILayout.Space(8f);
    }
}
#endif
