using System;
using Texel;
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

namespace ArchiTech.ProTV
{
    public class TVManager : UdonSharpBehaviour
    {
        public TXLVideoPlayer videoPlayer;
        public AudioManager manager;
        
        // This is the float other scripts will fetch. It gets updated automatically.
        public float volume;

        public void Start()
        {
            if (Utilities.IsValid(videoPlayer))
            {
                manager = videoPlayer.AudioManager;
                _RegisterVideoListeners();
            }
        }

        private void OnDestroy()
        {
            _UnregisterVideoListeners();
        }

        // -----------------------------------------------------------
        // Compatibility methods for external scripts SETTING the volume
        // -----------------------------------------------------------

        public void _ChangeVolume(float useVolume, bool suppress = false)
        {
            _UpdateVolumeSlider(useVolume);
        }

        public void _UpdateVolumeSlider(float newVolume)
        {
            if (Utilities.IsValid(manager))
            {
                // This tells Texel to update its volume. 
                // Texel will then fire EVENT_MASTER_VOLUME_UPDATE, which updates our float.
                manager._SetMasterVolume(newVolume);
            }
        }

        // -----------------------------------------------------------
        // The "Unholy" Syncing Logic (Texel Event Listeners)
        // -----------------------------------------------------------

        private void _RegisterVideoListeners()
        {
            if (Utilities.IsValid(videoPlayer))
            {
                videoPlayer._Register(TXLVideoPlayer.EVENT_BIND_AUDIOMANAGER, this, nameof(_InternalOnBindAudioManager));
                videoPlayer._Register(TXLVideoPlayer.EVENT_UNBIND_AUDIOMANAGER, this, nameof(_InternalOnUnbindAudioManager));
            }
            _RegisterAudioManagerListeners();
        }

        private void _UnregisterVideoListeners()
        {
            if (Utilities.IsValid(videoPlayer))
            {
                videoPlayer._Unregister(TXLVideoPlayer.EVENT_BIND_AUDIOMANAGER, this, nameof(_InternalOnBindAudioManager));
                videoPlayer._Unregister(TXLVideoPlayer.EVENT_UNBIND_AUDIOMANAGER, this, nameof(_InternalOnUnbindAudioManager));
            }
            _UnregisterAudioManagerListeners();
        }

        public void _InternalOnBindAudioManager()
        {
            manager = videoPlayer.AudioManager;
            _RegisterAudioManagerListeners();
        }

        public void _InternalOnUnbindAudioManager()
        {
            _UnregisterAudioManagerListeners();
            manager = null;
        }

        private void _RegisterAudioManagerListeners()
        {
            if (Utilities.IsValid(manager))
            {
                manager._Register(AudioManager.EVENT_MASTER_VOLUME_UPDATE, this, nameof(_InternalOnMasterVolumeUpdate));
                
                // Manually trigger once on setup so the float is accurate on world load
                _InternalOnMasterVolumeUpdate();
            }
        }

        private void _UnregisterAudioManagerListeners()
        {
            if (Utilities.IsValid(manager))
            {
                manager._Unregister(AudioManager.EVENT_MASTER_VOLUME_UPDATE, this, nameof(_InternalOnMasterVolumeUpdate));
            }
        }

        public void _InternalOnMasterVolumeUpdate()
        {
            if (Utilities.IsValid(manager))
            {
                // Here is the magic. We pull the actual volume from Texel's AudioManager 
                // and assign it to our legacy ProTV float.
                volume = manager.masterVolume;
            }
        }
    }
}