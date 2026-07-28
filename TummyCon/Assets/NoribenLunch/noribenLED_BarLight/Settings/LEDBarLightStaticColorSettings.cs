using UnityEngine;
using VRC.SDKBase;

public class LEDBarLightStaticColorSettings : MonoBehaviour, IEditorOnly
{
    [SerializeField] private LEDBarLightVideoInput RuntimeSupport;
    [SerializeField] private Texture SampleTexture;
    [SerializeField] private Material[] TargetMaterials;
}
