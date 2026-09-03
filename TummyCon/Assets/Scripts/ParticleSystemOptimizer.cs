
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class ParticleSystemOptimizer : UdonSharpBehaviour
{
    public ParticleSystem myParticleSystem;

    public override void OnPlayerTriggerEnter(VRCPlayerApi player)
    {
        if (player.isLocal)
        {
            var lightModule = myParticleSystem.lights;
            lightModule.enabled = true;
        }
    }

    public override void OnPlayerTriggerExit(VRCPlayerApi player)
    {
        if (player.isLocal)
        {
            var lightModule = myParticleSystem.lights;
            lightModule.enabled = false;
        }
    }
}
