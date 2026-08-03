
using UdonSharp;
using UnityEngine;
using UnityShaderParser.HLSL;
using VRC.SDKBase;
using VRC.Udon;

public class StageToggle : UdonSharpBehaviour
{
    public GameObject[] _stageParts;
    [HideInInspector] public int dialCurrentPosition;
    [HideInInspector] public float dialCurrentAngle;
    
    public void OnDialChanged()
    {
        Debug.Log($"[Dial Target] Position: {dialCurrentPosition} | Angle: {dialCurrentAngle}");

        switch (dialCurrentPosition)
        {
            case 0:
                foreach(GameObject stagePart in _stageParts) stagePart.SetActive(false);
                break;
            case 1:
                foreach (GameObject stagePart in _stageParts) stagePart.SetActive(true);
                break;
        }
    }
    
    
    
}
