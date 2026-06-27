using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using VRC.SDK3.Components; 

public class SpawnElevator : UdonSharpBehaviour
{
    [Header("Elevator Doors")]
    public GameObject leftDoor;
    public GameObject rightDoor;
    
    [Tooltip("Distance in meters to move on the Z axis")]
    public float zOffset = 1.5f; 
    public float doorSpeed = 1.0f;
    
    [Header("Audio")]
    public AudioSource dingSound;

    [UdonSynced]
    private int playersInside = 0;
    
    private Vector3 leftClosedPos;
    private Vector3 rightClosedPos;
    private bool isOpen = false;

    // Array to track specific players. 82 is the hard cap for a VRChat instance.
    private int[] trackedPlayerIDs = new int[100];

    void Start()
    {
        leftClosedPos = leftDoor.transform.localPosition;
        rightClosedPos = rightDoor.transform.localPosition;

        // Initialize the array with -1 (empty slots)
        for (int i = 0; i < trackedPlayerIDs.Length; i++)
        {
            trackedPlayerIDs[i] = -1;
        }
    }

    public override void OnPlayerTriggerEnter(VRCPlayerApi player)
    {
        if (player == null) return;

        if (Networking.LocalPlayer.IsOwner(gameObject))
        {
            AddPlayer(player.playerId);
            UpdateSyncedCount();
        }
    }

    public override void OnPlayerTriggerExit(VRCPlayerApi player)
    {
        if (player == null) return;

        if (Networking.LocalPlayer.IsOwner(gameObject))
        {
            RemovePlayer(player.playerId);
            UpdateSyncedCount();
        }
    }

    public override void OnPlayerLeft(VRCPlayerApi player)
    {
        // Catch disconnects. This fires for all clients, but only the Owner acts on it.
        if (player != null && Networking.LocalPlayer.IsOwner(gameObject))
        {
            RemovePlayer(player.playerId);
            UpdateSyncedCount();
        }
    }

    private void AddPlayer(int id)
    {
        // Prevent duplicate entries
        for (int i = 0; i < trackedPlayerIDs.Length; i++)
        {
            if (trackedPlayerIDs[i] == id) return;
        }
        
        // Slot the ID into the first available empty index
        for (int i = 0; i < trackedPlayerIDs.Length; i++)
        {
            if (trackedPlayerIDs[i] == -1)
            {
                trackedPlayerIDs[i] = id;
                return;
            }
        }
    }

    private void RemovePlayer(int id)
    {
        // Find the player ID and remove it
        for (int i = 0; i < trackedPlayerIDs.Length; i++)
        {
            if (trackedPlayerIDs[i] == id)
            {
                trackedPlayerIDs[i] = -1;
                return;
            }
        }
    }

    private void UpdateSyncedCount()
    {
        // Recalculate the true count based on the array
        int currentCount = 0;
        for (int i = 0; i < trackedPlayerIDs.Length; i++)
        {
            if (trackedPlayerIDs[i] != -1) currentCount++;
        }

        // Only update and serialize if the number actually changed
        if (playersInside != currentCount)
        {
            playersInside = currentCount;
            RequestSerialization();
            UpdateElevatorState();
        }
    }

    public override void OnDeserialization()
    {
        UpdateElevatorState();
    }

    private void UpdateElevatorState()
    {
        bool shouldBeOpen = (playersInside > 0);

        if (shouldBeOpen && !isOpen)
        {
            isOpen = true;
            if (dingSound != null) dingSound.Play();

            leftDoor.TweenLocalPosition(leftClosedPos + new Vector3(0, 0, zOffset), doorSpeed, VRCTweenEase.OutQuad);
            rightDoor.TweenLocalPosition(rightClosedPos + new Vector3(0, 0, -zOffset), doorSpeed, VRCTweenEase.OutQuad);
        }
        else if (!shouldBeOpen && isOpen)
        {
            isOpen = false;

            leftDoor.TweenLocalPosition(leftClosedPos, doorSpeed, VRCTweenEase.InOutQuad);
            rightDoor.TweenLocalPosition(rightClosedPos, doorSpeed, VRCTweenEase.InOutQuad);
        }
    }
}