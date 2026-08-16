#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;

// Tells Unity to apply this interface to our UdonSharp script
[CustomEditor(typeof(RigidbodyAreaOptimizer))]
public class RigidbodyAreaOptimizerEditor : Editor
{
    public override void OnInspectorGUI()
    {
        // Draw the default variables
        base.OnInspectorGUI();

        RigidbodyAreaOptimizer script = (RigidbodyAreaOptimizer)target;

        GUILayout.Space(15);
        
        // Create the Button
        if (GUILayout.Button("Find & Assign All Child Rigidbodies", GUILayout.Height(35)))
        {
            // Register an undo state so you can hit Ctrl+Z if you make a mistake
            Undo.RecordObject(script, "Auto-Assign Rigidbodies");

            // GetComponentsInChildren with 'true' checks as deep as it can go, 
            // and also includes currently disabled gameobjects!
            script.rigidbodies = script.GetComponentsInChildren<Rigidbody>(true);
            
            // Tell Unity to save the change we just made
            EditorUtility.SetDirty(script);
            
            Debug.Log($"[Rigidbody Optimizer] Success! Found and assigned {script.rigidbodies.Length} rigidbodies.");
        }
    }
}
#endif