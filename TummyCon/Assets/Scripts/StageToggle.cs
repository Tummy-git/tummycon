
using UdonSharp;
using UnityEngine;

public class StageToggle : UdonSharpBehaviour
{
    public GameObject[] _stageParts;
    [HideInInspector, UdonSynced] public int dialCurrentPosition;
    [HideInInspector] public float dialCurrentAngle;
    
    public void OnDialChanged()
    {
        Debug.Log($"[Dial Target] Position: {dialCurrentPosition} | Angle: {dialCurrentAngle}");

        RequestSerialization();
        OnDeserialization();
    }

    public override void OnDeserialization()
    {
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
