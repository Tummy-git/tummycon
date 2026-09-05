
using System;
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class MusicExtrasDisableScript : UdonSharpBehaviour
{
    
    public GameObject[] _gameObjects;
    
    public void ObjectsOnButton()
    {
        ObjectToggleFunc(true);
    }
    public void ObjectsOffButton()
    {
        ObjectToggleFunc(false);
    }

    private void OnDisable()  //This one forces all the objects on for the player.
    {
        ObjectToggleFunc(true);
    }

    public void ObjectToggleFunc(bool setState)
    {
        foreach (GameObject go in _gameObjects)
        {
            go.SetActive(setState);
            Debug.Log($"Set gameobject {go.name} to {setState}");
        }
    }
}
