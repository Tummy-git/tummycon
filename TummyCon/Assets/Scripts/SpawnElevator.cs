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

    void Start()
    {
        // Cache the default closed positions
        leftClosedPos = leftDoor.transform.localPosition;
        rightClosedPos = rightDoor.transform.localPosition;
    }

    public override void OnPlayerTriggerEnter(VRCPlayerApi player)
    {
        // Only the network owner tracks the count to prevent duplicate network events
        if (Networking.LocalPlayer.IsOwner(gameObject))
        {
            playersInside++;
            RequestSerialization();
            UpdateElevatorState();
        }
    }

    public override void OnPlayerTriggerExit(VRCPlayerApi player)
    {
        if (Networking.LocalPlayer.IsOwner(gameObject))
        {
            playersInside--;
            if (playersInside < 0) playersInside = 0; // Failsafe
            RequestSerialization();
            UpdateElevatorState();
        }
    }

    public override void OnDeserialization()
    {
        // Late joiners and observing clients evaluate the state when the synced variable updates
        UpdateElevatorState();
    }

    private void UpdateElevatorState()
    {
        bool shouldBeOpen = (playersInside > 0);

        if (shouldBeOpen && !isOpen)
        {
            isOpen = true;
            if (dingSound != null) dingSound.Play();

            // VRCTween handles the smooth translation
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