using System.Collections;
using System.Collections.Generic;
using UdonSharpEditor;
using UnityEditor;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Rasta.UnyStylus
{

    public class UnyStylusBuildProcess : IProcessSceneWithReport
    {
        public int callbackOrder => 0;

        public void OnProcessScene(Scene scene, BuildReport report)
        {
            UnyStylusController[] unyStylusController = GameObject.FindObjectsByType<UnyStylusController>(FindObjectsInactive.Include, FindObjectsSortMode.None);
            if (unyStylusController.Length == 0) return;
            
            GameObject unyStylusPoolGameObject = new GameObject("UnyStylusPool");

            LinePool unyStylusPool = unyStylusPoolGameObject.AddUdonSharpComponent<LinePool>();
            
            foreach (var controller in unyStylusController)
            {
                controller.linePool = unyStylusPool;
            }
        }
    }
}