#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;

[CustomEditor(typeof(LEDBarLightSystemSettings))]
public class LEDBarLightSystemSettingsEditor : Editor
{
    private enum InspectorLanguage
    {
        Japanese,
        English
    }

    private const string LanguagePrefKey =
        "Noriben.LEDBarLightSystem.InspectorLanguage";

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

        LEDBarLightSystemSettings settings =
            (LEDBarLightSystemSettings)target;
        LEDBarLightVideoInput videoInput =
            settings.GetComponent<LEDBarLightVideoInput>();
        Material[] targetMaterials =
            LEDBarLightAudioLinkEditorUtility.GetTargetMaterials(videoInput);

        SerializedProperty videoInputProperty =
            serializedObject.FindProperty("VideoInput");
        if (videoInputProperty.objectReferenceValue != videoInput)
        {
            videoInputProperty.objectReferenceValue = videoInput;
        }

        EditorGUILayout.LabelField(
            IsJapanese ? "動画入力" : "Video Input",
            EditorStyles.boldLabel);
        EditorGUILayout.BeginVertical(EditorStyles.helpBox);
        LEDBarLightVideoInputEditorUtility.Draw(
            videoInput,
            settings.transform,
            IsJapanese);
        EditorGUILayout.EndVertical();

        EditorGUILayout.Space(8f);
        LEDBarLightAudioLinkEditorUtility.DrawSettings(
            targetMaterials,
            IsJapanese);

        EditorGUILayout.Space(8f);
        LEDBarLightDepthEditorUtility.Draw(
            videoInput,
            targetMaterials,
            IsJapanese);

        serializedObject.ApplyModifiedProperties();
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
            "LED BarLight System - Movie Color",
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
