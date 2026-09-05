
using System;
using ArchiTech.ProTV;
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using VRRefAssist;

public class MusicExtrasDisableScript : UdonSharpBehaviour
{
    [SerializeField, FindObjectOfType] private TVManager tv;
    public GameObject[] _gameObjects;
    private float originalVolume = 0.5f;
    
    
    public void ObjectsOnButton()
    {
        ObjectToggleFunc(true);
    }
    public void ObjectsOffButton()
    {
        originalVolume = tv.volume;
        ObjectToggleFunc(false);
        tv._ChangeVolume(originalVolume);
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
