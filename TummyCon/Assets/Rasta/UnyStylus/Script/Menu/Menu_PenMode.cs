
using System;
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDK3.Components;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    public enum UnyStylusMode
    {
        Draw = 0,
        Erase = 1,
        Select = 2,
        ColorPick = 10
    }

    [UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
    public class Menu_PenMode : UdonSharpBehaviour
    {
        [SerializeField] private UnyStylusController controller;
        [SerializeField] private Toggle drawToggle;
        [SerializeField] private Toggle eraseToggle;
        [SerializeField] private Toggle selectToggle;
        [SerializeField] private Toggle colorPickToggle;
        [SerializeField] private VRCPickup pickup;
        [SerializeField] private Pen unyStylusPen;
        [SerializeField] private Eraser unyStylusEraser;
        [SerializeField] private LineSelector unyStylusSelector;
        [SerializeField] private Menu_WidthSlider widthSliderMenu;
        [SerializeField] private ColorPicker colorPicker;
        [SerializeField] private Menu_Clear menu_Clear;
        [Space(10)]
        [SerializeField] private GameObject drawSmallMenu;
        [SerializeField] private Toggle drawSmoothToggle;
        [SerializeField] private Toggle drawLineToggle;
        [SerializeField] private Toggle drawOnSurfaceToggle;
        [SerializeField] private ToggleGroup layerToggleGroup;
        [SerializeField] private Toggle layer1Toggle;
        [SerializeField] private Toggle layer2Toggle;
        [SerializeField] private Toggle layer3Toggle;
        [Space(10)]
        [SerializeField] private GameObject selectSmallMenu;
        [SerializeField] private Toggle selectMoveToggle;
        [SerializeField] private Toggle selectDuplicateToggle;

        private DateTime[] useDownTimes = new DateTime[2];

        private float[] moveDistances = new float[4]; 
        private Vector3 beforePositions = Vector3.zero;

        [UdonSynced, FieldChangeCallback(nameof(SyncedPenMode))] private int syncedPenMode = 0;
        [UdonSynced, FieldChangeCallback(nameof(SyncedDrawMode))] private int syncedDrawMode = 0;
        [UdonSynced, FieldChangeCallback(nameof(SyncedLayerId))] private byte syncedLayerId = 0;
        [UdonSynced, FieldChangeCallback(nameof(SyncedSelectMode))] private int syncedSelectMode = 0;
        [UdonSynced, FieldChangeCallback(nameof(SyncedIsOnSurface))] private bool syncedIsOnSurface = false;

        void Start()
        {
            if (Networking.IsOwner(gameObject))
            {
                SyncedPenMode = 0;
                SyncedDrawMode = 0;
                SyncedSelectMode = 0;

                beforePositions = controller.penTipTransform.position;
                useDownTimes[0] = DateTime.MinValue;
                useDownTimes[1] = DateTime.MinValue;
            }
        }

        void Update()
        {
            if (Networking.IsOwner(gameObject))
            {
                moveDistances[0] += Vector3.Distance(controller.penTipTransform.position, beforePositions);
                beforePositions = controller.penTipTransform.position;
            }
        }

        public void OnUnyStylusPickupUseDown()
        {
            for (int i = 0; i < moveDistances.Length - 1; i++)
            {
                moveDistances[i + 1] = moveDistances[i];
            }
            moveDistances[0] = 0f;

            useDownTimes[1] = useDownTimes[0];
            useDownTimes[0] = DateTime.Now;
        }

        public void OnUnyStylusPickupUseUp()
        {
            float totalDistance = 0f;
            for (int i = moveDistances.Length - 2; i >= 0; i--)
            {
                totalDistance += moveDistances[i];
                moveDistances[i + 1] = moveDistances[i];
            }
            moveDistances[0] = 0f;

            if (
                (DateTime.Now - useDownTimes[1]).TotalSeconds < 0.5 && 
                totalDistance < 0.02f * controller.unyStylus.transform.localScale.x
                )
            {
                SyncedPenMode = SyncedPenMode != (int)UnyStylusMode.Draw ? (int)UnyStylusMode.Draw : (int)UnyStylusMode.Erase;
            }
        }

        public void OnUnyStylusDrop()
        {
            SyncedPenMode = (int)UnyStylusMode.Draw;
        }

        public void OnDrawToggleChanged()
        {
            if (drawToggle.isOn)
            {
                SyncedPenMode = (int)UnyStylusMode.Draw;
            }
        }
        public void OnEraseToggleChanged()
        {
            if (eraseToggle.isOn)
            {
                SyncedPenMode = (int)UnyStylusMode.Erase;
            }
        }
        public void OnSelectToggleChanged()
        {
            if (selectToggle.isOn)
            {
                SyncedPenMode = (int)UnyStylusMode.Select;
            }
        }
        public void OnColorPickToggleChanged()
        {
            if (colorPickToggle.isOn)
            {
                SyncedPenMode = (int)UnyStylusMode.ColorPick;
            }
        }

        public int SyncedPenMode
        {
            set
            {
                bool isChanged = syncedPenMode != value;
                syncedPenMode = value;
                drawToggle.SetIsOnWithoutNotify(syncedPenMode == (int)UnyStylusMode.Draw);
                eraseToggle.SetIsOnWithoutNotify(syncedPenMode == (int)UnyStylusMode.Erase);
                selectToggle.SetIsOnWithoutNotify(syncedPenMode == (int)UnyStylusMode.Select);

                if (isChanged)
                {
                    unyStylusPen.OnChangedPenMode();
                    unyStylusEraser.OnChangedPenMode();
                    unyStylusSelector.OnChangedPenMode();
                    widthSliderMenu.OnChangedPenMode();
                    colorPicker.OnChangedPenMode();
                }

                drawSmallMenu.SetActive(syncedPenMode == (int)UnyStylusMode.Draw);
                selectSmallMenu.SetActive(syncedPenMode == (int)UnyStylusMode.Select);

                if (Networking.IsOwner(gameObject))
                {
                    RequestSerialization();
                }
            }
            get => syncedPenMode;
        }

        public void OnDrawSmoothToggleChanged()
        {
            if (drawSmoothToggle.isOn)
            {
                SyncedDrawMode = 0;
            }
        }

        public void OnDrawLineToggleChanged()
        {
            if (drawLineToggle.isOn)
            {
                SyncedDrawMode = 1;
            }
        }

        public int SyncedDrawMode
        {
            set
            {
                syncedDrawMode = value;

                drawSmoothToggle.SetIsOnWithoutNotify(syncedDrawMode == 0);
                drawLineToggle.SetIsOnWithoutNotify(syncedDrawMode == 1);

                if (Networking.IsOwner(gameObject))
                {
                    RequestSerialization();
                }
            }
            get => syncedDrawMode;
        }

        public void OnLayerChanged()
        {
            Toggle selected = layerToggleGroup.GetFirstActiveToggle();
            if (selected == layer1Toggle)
            {
                SyncedLayerId = 0;
            }
            else if (selected == layer2Toggle)
            {
                SyncedLayerId = 1;
            }
            else if (selected == layer3Toggle)
            {
                SyncedLayerId = 2;
            }
        }

        public byte SyncedLayerId
        {
            set
            {
                syncedLayerId = value;

                layer1Toggle.SetIsOnWithoutNotify(syncedLayerId == 0);
                layer2Toggle.SetIsOnWithoutNotify(syncedLayerId == 1);
                layer3Toggle.SetIsOnWithoutNotify(syncedLayerId == 2);
                menu_Clear.OnChangedLayerId();

                if (Networking.IsOwner(gameObject))
                {
                    RequestSerialization();
                }
            }
            get => syncedLayerId;
        }

        public void OnSelectMoveToggleChanged()
        {
            if (selectMoveToggle.isOn)
            {
                SyncedSelectMode = 0;
            }
        }

        public void OnSelectDuplicateToggleChanged()
        {
            if (selectDuplicateToggle.isOn)
            {
                SyncedSelectMode = 1;
            }
        }

        public int SyncedSelectMode
        {
            set
            {
                syncedSelectMode = value;

                selectMoveToggle.SetIsOnWithoutNotify(syncedSelectMode == 0);
                selectDuplicateToggle.SetIsOnWithoutNotify(syncedSelectMode == 1);

                unyStylusSelector.OnSyncedSelectModeChanged();

                if (Networking.IsOwner(gameObject))
                {
                    RequestSerialization();
                }
            }
            get => syncedSelectMode;
        }

        public void OnDrawOnSurfaceToggleChanged()
        {
            SyncedIsOnSurface = drawOnSurfaceToggle.isOn;
        }

        public bool SyncedIsOnSurface
        {
            set
            {
                syncedIsOnSurface = value;

                drawOnSurfaceToggle.SetIsOnWithoutNotify(syncedIsOnSurface);

                if (Networking.IsOwner(gameObject))
                {
                    RequestSerialization();
                }
            }
            get => syncedIsOnSurface;
        }
    }
}
