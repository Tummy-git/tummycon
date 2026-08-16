using UdonSharp;
using UnityEngine;
using VRC.SDKBase;

public class RigidbodyAreaOptimizer : UdonSharpBehaviour
{
    [Header("Assign manually or use the button below")]
    public Rigidbody[] rigidbodies;

    [Header("Settings")]
    [Tooltip("If true, rigidbodies will be disabled on world load until you enter.")]
    public bool disableOnStart = true;

    void Start()
    {
        if (disableOnStart)
        {
            SetRigidbodiesState(true); // true = make them kinematic (disabled)
        }
    }

    public override void OnPlayerTriggerEnter(VRCPlayerApi player)
    {
        // We only care about the local player triggering the area
        if (player != null && player.isLocal)
        {
            SetRigidbodiesState(false); // false = turn physics ON
        }
    }

    public override void OnPlayerTriggerExit(VRCPlayerApi player)
    {
        if (player != null && player.isLocal)
        {
            SetRigidbodiesState(true); // true = turn physics OFF
        }
    }

    private void SetRigidbodiesState(bool makeKinematic)
    {
        if (rigidbodies == null) return;

        foreach (Rigidbody rb in rigidbodies)
        {
            if (rb != null)
            {
                rb.isKinematic = makeKinematic;
                
                if (makeKinematic)
                {
                    rb.Sleep(); // Instantly stops calculating physics for this object
                }
                else
                {
                    rb.WakeUp(); // Re-engages the physics engine
                }
            }
        }
    }
}