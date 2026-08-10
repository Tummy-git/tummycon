using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using UnityEditorInternal;
#if !COMPILER_UDONSHARP && UNITY_EDITOR
using UnityEditor;
using UdonSharpEditor;

namespace Rasta.UnyStylus.CustomTouchableCanvas.Editor
{
    [CustomEditor(typeof(TACEventTrigger))]
    public class TAC_EventTriggerEditor : UnityEditor.Editor
    {
        private ReorderableList[] reorderbleLists;
        private SerializedProperty[] serializedProperty_BehavioursProp;
        private SerializedProperty[] serializedProperty_EventNamesProp;

        private void OnEnable()
        {
            int count = 6;
            serializedProperty_BehavioursProp = new SerializedProperty[count];
            serializedProperty_EventNamesProp = new SerializedProperty[count];
            reorderbleLists = new ReorderableList[count];

            serializedProperty_BehavioursProp[0] = serializedObject.FindProperty(nameof(TACEventTrigger.pointerDownUB));
            serializedProperty_BehavioursProp[1] = serializedObject.FindProperty(nameof(TACEventTrigger.pointerUpUB));
            serializedProperty_BehavioursProp[2] = serializedObject.FindProperty(nameof(TACEventTrigger.pointerClickUB));
            serializedProperty_BehavioursProp[3] = serializedObject.FindProperty(nameof(TACEventTrigger.beginDragUB));
            serializedProperty_BehavioursProp[4] = serializedObject.FindProperty(nameof(TACEventTrigger.dragUB));
            serializedProperty_BehavioursProp[5] = serializedObject.FindProperty(nameof(TACEventTrigger.endDragUB));

            serializedProperty_EventNamesProp[0] = serializedObject.FindProperty(nameof(TACEventTrigger.pointerDownEventNames));
            serializedProperty_EventNamesProp[1] = serializedObject.FindProperty(nameof(TACEventTrigger.pointerUpEventNames));
            serializedProperty_EventNamesProp[2] = serializedObject.FindProperty(nameof(TACEventTrigger.pointerClickEventNames));
            serializedProperty_EventNamesProp[3] = serializedObject.FindProperty(nameof(TACEventTrigger.beginDragEventNames));
            serializedProperty_EventNamesProp[4] = serializedObject.FindProperty(nameof(TACEventTrigger.dragEventNames));
            serializedProperty_EventNamesProp[5] = serializedObject.FindProperty(nameof(TACEventTrigger.endDragEventNames));

            reorderbleLists[0] = CreateReorderableList("Pointer Down", serializedProperty_BehavioursProp[0], serializedProperty_EventNamesProp[0]);
            reorderbleLists[1] = CreateReorderableList("Pointer Up", serializedProperty_BehavioursProp[1], serializedProperty_EventNamesProp[1]);
            reorderbleLists[2] = CreateReorderableList("Pointer Click", serializedProperty_BehavioursProp[2], serializedProperty_EventNamesProp[2]);
            reorderbleLists[3] = CreateReorderableList("Begin Drag", serializedProperty_BehavioursProp[3], serializedProperty_EventNamesProp[3]);
            reorderbleLists[4] = CreateReorderableList("Drag", serializedProperty_BehavioursProp[4], serializedProperty_EventNamesProp[4]);
            reorderbleLists[5] = CreateReorderableList("End Drag", serializedProperty_BehavioursProp[5], serializedProperty_EventNamesProp[5]);
        }

        private ReorderableList CreateReorderableList(string header, SerializedProperty behavioursProp, SerializedProperty eventNamesProp)
        {
            var list = new ReorderableList(serializedObject, behavioursProp, true, true, true, true);
            list.drawHeaderCallback = (Rect rect) =>
            {
                EditorGUI.LabelField(rect, header);
            };

            list.elementHeightCallback = (index) => EditorGUIUtility.singleLineHeight;

            list.drawElementCallback = (Rect rect, int index, bool isActive, bool isFocused) =>
            {
                rect.y += 1;
                var behaviourRect = new Rect(rect.x, rect.y, rect.width * 2 / 7, EditorGUIUtility.singleLineHeight);
                var eventRect = new Rect(rect.x + rect.width * 2 / 7 + 5, rect.y, rect.width * 5 / 7 - 5, EditorGUIUtility.singleLineHeight);

                if (index < behavioursProp.arraySize && index < eventNamesProp.arraySize)
                {
                    EditorGUI.PropertyField(behaviourRect, behavioursProp.GetArrayElementAtIndex(index), GUIContent.none);
                    EditorGUI.PropertyField(eventRect, eventNamesProp.GetArrayElementAtIndex(index), GUIContent.none);
                }
            };

            list.onAddCallback = (ReorderableList list) =>
            {
                behavioursProp.arraySize++;
                eventNamesProp.arraySize++;
                serializedObject.ApplyModifiedProperties();
            };

            list.onRemoveCallback = (ReorderableList list) =>
            {
                int index = list.index;
                if (index >= 0)
                {
                    behavioursProp.DeleteArrayElementAtIndex(index);
                    eventNamesProp.DeleteArrayElementAtIndex(index);
                    serializedObject.ApplyModifiedProperties();
                }
            };

            return list;
        }

        public override void OnInspectorGUI()
        {
            if (UdonSharpGUI.DrawDefaultUdonSharpBehaviourHeader(target)) return;

            serializedObject.Update();

            foreach (var l in reorderbleLists)
            {
                l.DoLayoutList();
            }
            serializedObject.ApplyModifiedProperties();
        }
    }
}
#endif
