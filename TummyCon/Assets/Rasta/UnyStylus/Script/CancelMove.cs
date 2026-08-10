
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.NoVariableSync)]
    public class CancelMove : UdonSharpBehaviour
    {
        [SerializeField] private LineSelector lineSelector;

        public override void Interact()
        {
            lineSelector.SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, nameof(LineSelector.CancelSyncing));
        }
    }
}
