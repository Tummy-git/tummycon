using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class ObjectWhitelist : UdonSharpBehaviour
{
    public string[] _playerNames;
    public GameObject[] _objects;

    public override void OnPlayerJoined(VRCPlayerApi player)
    {
        // Only run this logic for the local player who just joined
        if (!player.isLocal) return;

        bool isWhitelisted = false;

        // 1. Check if the player is in the whitelist
        foreach (string name in _playerNames)
        {
            if (name == player.displayName)
            {
                isWhitelisted = true;
                break; // We found a match, so we can stop checking the rest of the names
            }
        }

        // 2. Enable or disable all objects in the array based on the result
        foreach (GameObject obj in _objects)
        {
            if (obj != null) // It's good practice to ensure the object isn't empty/null
            {
                obj.SetActive(isWhitelisted);
            }
        }
    }
}