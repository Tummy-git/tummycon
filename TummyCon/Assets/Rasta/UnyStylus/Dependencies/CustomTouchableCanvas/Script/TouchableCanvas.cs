
using System;
using System.Linq;
using UdonSharp;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using VRC.SDK3.Components;
using VRC.SDK3.Data;
using VRC.SDKBase;
using VRC.Udon;
using VRC.Udon.Common;

namespace Rasta.UnyStylus.CustomTouchableCanvas
{
    public enum TouchHand
    {
        None,
        LeftHand,
        RightHand,
    }

    [RequireComponent(typeof(Canvas))]
    public class TouchableCanvas : UdonSharpBehaviour
    {
        [SerializeField] private float showPointerHeight = 0.15f;

        public bool isPushable = true;
        [SerializeField] private bool laserOnly = false;
        [SerializeField] private Transform pressedMoveTarget;
        [SerializeField] private float pushDistanceLimit = 0.05f;
        [SerializeField] private bool hapticFeedback = true;
        [SerializeField] private float hapticDuration = 0.1f;
        [SerializeField] private float hapticAmplitude = 0.1f;
        [SerializeField] private float hapticFrequency = 150;
        [SerializeField] private float dragDist = 50;
        [Space(10)]
        [SerializeField] private bool forceVRMode = false;
        [SerializeField] private UdonBehaviour[] callbackScripts;

        public TACPointer[] pointers;

        private SphereCollider[] pointersSphereCollider;

        private Canvas canvas;
        private RectTransform canvasRect;
        private object _otac_selectable;
        private object _otac_toggle;
        private object _otac_button;
        private object _otac_slider;
        private object _otac_scrollbar;
        private object _otac_scrollRect;
        private object _otac_dropdown;
        private object _otac_vrcUrlInputField;
        private object _otac_eventTrigger;
        private TACSelectableLogic tac_selectable { get { return (TACSelectableLogic)_otac_selectable; } set { _otac_selectable = (object)value; } }
        private TACToggleLogic tac_toggle { get { return (TACToggleLogic)_otac_toggle; } set { _otac_toggle = (object)value; } }
        private TACButtonLogic tac_button { get { return (TACButtonLogic)_otac_button; } set { _otac_button = (object)value; } }
        private TACSliderLogic tac_slider { get { return (TACSliderLogic)_otac_slider; } set { _otac_slider = (object)value; } }
        private TACScrollbarLogic tac_scrollbar { get { return (TACScrollbarLogic)_otac_scrollbar; } set { _otac_scrollbar = (object)value; } }
        private TACScrollRectLogic tac_scrollRect { get { return (TACScrollRectLogic)_otac_scrollRect; } set { _otac_scrollRect = (object)value; } }
        private TACDropdownLogic tac_dropdown { get { return (TACDropdownLogic)_otac_dropdown; } set { _otac_dropdown = (object)value; } }
        private TACVrcUrlInputFieldLogic tac_vrcUrlInputField { get { return (TACVrcUrlInputFieldLogic)_otac_vrcUrlInputField; } set { _otac_vrcUrlInputField = (object)value; } }
        private TACEventTriggerLogic tac_eventTrigger { get { return (TACEventTriggerLogic)_otac_eventTrigger; } set { _otac_eventTrigger = (object)value; } }

        // touch
        private bool[] isPointerEntered;
        private bool[] isBefTouchPosIsMinusZ;
        private Vector3 canvasOffset = Vector3.zero;
        private Vector3 initialPressedMoveTargetLocalPosition = Vector3.zero;
        private Vector2[] touchPos;
        private bool[] isDrag;
        private bool[] isFindDragableUI;
        private Vector2[] dragStartPos;
        private bool isDesktopMode = false;

        private BoxCollider canvasCollider;

        private Transform[] targetTfs;

        DataDictionary emptyDataDictionaly = new DataDictionary();

        private DataList vrcUrlActiveList = new DataList();

        private PointerEventData pointerEventData = new PointerEventData(EventSystem.current);

        void Start()
        {
            // pointers[0].gameObject.SetActive(true); // left index finger
            // pointers[1].gameObject.SetActive(true); // right index finger

            pointersSphereCollider = new SphereCollider[pointers.Length];
            for (int i = 0; i < pointers.Length; i++)
            {
                pointersSphereCollider[i] = pointers[i].GetComponent<SphereCollider>();
            }

            canvas = GetComponent<Canvas>();
            canvasRect = GetComponent<RectTransform>();
            if (!Utilities.IsValid(pressedMoveTarget))
            {
                pressedMoveTarget = transform;
            }
            initialPressedMoveTargetLocalPosition = pressedMoveTarget.localPosition;
            if (Utilities.IsValid(pressedMoveTarget.parent))
            {
                canvasOffset = pressedMoveTarget.parent.InverseTransformPoint(transform.position) - pressedMoveTarget.localPosition;
            }
            else
            {
                canvasOffset = transform.position - pressedMoveTarget.position;
            }

            tac_selectable = TACSelectableLogic.New(pointers.Length);
            tac_toggle = TACToggleLogic.New(pointers.Length);
            tac_button = TACButtonLogic.New(pointers.Length);
            tac_slider = TACSliderLogic.New(pointers.Length);
            tac_scrollbar = TACScrollbarLogic.New(pointers.Length);
            tac_scrollRect = TACScrollRectLogic.New(pointers.Length);
            tac_dropdown = TACDropdownLogic.New(pointers.Length);
            tac_vrcUrlInputField = TACVrcUrlInputFieldLogic.New(pointers.Length);
            tac_eventTrigger = TACEventTriggerLogic.New(pointers.Length);

            isPointerEntered = new bool[pointers.Length];
            isBefTouchPosIsMinusZ = new bool[pointers.Length];
            touchPos = new Vector2[pointers.Length];
            isDrag = new bool[pointers.Length];
            isFindDragableUI = new bool[pointers.Length];
            dragStartPos = new Vector2[pointers.Length];

            targetTfs = new Transform[pointers.Length];

            isDesktopMode = !Networking.LocalPlayer.IsUserInVR() && !forceVRMode;

            canvasCollider = canvas.GetComponent<BoxCollider>();
            if (Utilities.IsValid(canvasCollider))
            {
                canvasCollider.enabled = isDesktopMode || laserOnly;
            }
        }

        void Update()
        {
            float _pushDistance = 0.0f;
            Transform pressedMoveParent = pressedMoveTarget.parent;

            Vector3 canvasGlobalPosition;
            Vector3 pressedMoveTargetGlobalPosition;
            if (Utilities.IsValid(pressedMoveParent))
            {
                canvasGlobalPosition = pressedMoveParent.TransformPoint(initialPressedMoveTargetLocalPosition + canvasOffset);
                pressedMoveTargetGlobalPosition = pressedMoveParent.TransformPoint(initialPressedMoveTargetLocalPosition);
            }
            else
            {
                canvasGlobalPosition = initialPressedMoveTargetLocalPosition + canvasOffset;
                pressedMoveTargetGlobalPosition = initialPressedMoveTargetLocalPosition;
            }

            if (!laserOnly)
            {
                for (int n = 0; n < pointers.Length; n++)
                {
                    SphereCollider sphere = pointersSphereCollider[n];

                    float sphereGlobalRadius = sphere.radius * Mathf.Max(sphere.transform.lossyScale.x, sphere.transform.lossyScale.y, sphere.transform.lossyScale.z);
                    float globalZDiff = Vector3.Dot(transform.forward, sphere.transform.position - canvasGlobalPosition) + sphereGlobalRadius;
                    Vector3 sphereWorldPos = sphere.transform.position + transform.forward * sphereGlobalRadius;
                    Vector3 sphereLocalPos = transform.InverseTransformPoint(sphereWorldPos);

                    bool isContain = canvasRect.rect.Contains(sphereLocalPos);
                    if (canvasRect.lossyScale.x == 0 || canvasRect.lossyScale.y == 0)
                    {
                        isContain = false;
                    }

                    pointers[n].isContain = pointers[n].isContain | (isContain && globalZDiff <= pushDistanceLimit && globalZDiff >= -showPointerHeight);

                    // Down -> BeginDrag -> Drag
                    // Up -> EndDrag -> Click

                    // OnPointerDown/Up
                    if (!isPointerEntered[n])
                    {
                        if (isContain && isBefTouchPosIsMinusZ[n] && globalZDiff >= 0 && globalZDiff <= pushDistanceLimit && sphere.enabled)
                        {
                            isPointerEntered[n] = true;
                            touchPos[n] = (Vector2)sphereLocalPos;
                            OnPointerDown(n, sphereWorldPos);
                        }
                    }
                    else
                    {
                        if (!isContain || globalZDiff < 0 || globalZDiff > pushDistanceLimit || !sphere.enabled)
                        {
                            isPointerEntered[n] = false;
                            OnPointerUp(n);
                            if (isFindDragableUI[n])
                            {
                                OnEndDrag(n);
                            }
                            if (isContain && globalZDiff < 0)
                            {
                                GameObject hitGameObject = Raycast(sphereWorldPos);
                                if (Utilities.IsValid(hitGameObject))
                                {
                                    Transform hitSelectable = FindInteractionUI(hitGameObject.transform);
                                    if (Utilities.IsValid(hitSelectable) && Utilities.IsValid(tac_selectable.GetSelectable(n)) && hitSelectable.gameObject == tac_selectable.GetSelectable(n).gameObject)
                                    {
                                        OnPointerClick(n);
                                    }
                                }
                            }
                            isDrag[n] = false;
                            isFindDragableUI[n] = false;
                        }
                    }

                    // Drag
                    if (isPointerEntered[n])
                    {
                        if (!isDrag[n])
                        {
                            float dist = Vector2.Distance((Vector2)sphereLocalPos, touchPos[n]);
                            if (dist > dragDist)
                            {
                                isDrag[n] = true;
                                dragStartPos[n] = (Vector2)sphereLocalPos;

                                Transform hitTf = FindDragableUI(targetTfs[n]);

                                if (Utilities.IsValid(hitTf))
                                {
                                    isFindDragableUI[n] = true;
                                    if (hitTf.gameObject != targetTfs[n].gameObject)
                                    {
                                        tac_selectable.OnPointerUp(n, pointerEventData);
                                        ClearTAC(n);

                                        tac_selectable.Init(n, hitTf.GetComponent<Selectable>());
                                        tac_slider.Init(n, hitTf.GetComponent<Slider>(), hitTf.gameObject, sphereWorldPos);
                                        tac_scrollbar.Init(n, hitTf.GetComponent<Scrollbar>(), hitTf.gameObject, sphereWorldPos);
                                        tac_scrollRect.Init(n, hitTf.GetComponent<ScrollRect>(), null, sphereWorldPos);
                                        tac_eventTrigger.SetEventTrigger(n, hitTf.GetComponent<TACEventTrigger>());
                                    }

                                    OnBeginDrag(n);
                                }
                            }
                        }
                        else if (isFindDragableUI[n])
                        {
                            OnDrag(n, sphere.transform.position);
                        }
                    }

                    isBefTouchPosIsMinusZ[n] = globalZDiff < 0;

                    if (isPointerEntered[n])
                    {
                        _pushDistance = Mathf.Max(_pushDistance, globalZDiff);
                    }
                }
            }

            if (isPushable)
            {
                if (_pushDistance == 0)
                {
                    pressedMoveTarget.localPosition = Vector3.Lerp(pressedMoveTarget.localPosition, initialPressedMoveTargetLocalPosition, Time.deltaTime * 10.0f);
                }
                else
                {
                    pressedMoveTarget.position = pressedMoveTargetGlobalPosition + transform.forward * _pushDistance;
                }
            }
            else
            {
                pressedMoveTarget.localPosition = Vector3.Lerp(pressedMoveTarget.localPosition, initialPressedMoveTargetLocalPosition, Time.deltaTime * 10.0f);
            }

            VRCPlayerApi.TrackingData trackingData;
            trackingData = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.Head);
            if (laserOnly)
            {
                trackingData = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.RightHand);
            }
        }

        private void ClearTAC(int n)
        {
            tac_selectable.Clear(n);
            tac_toggle.Clear(n);
            tac_button.Clear(n);
            tac_slider.Clear(n);
            tac_scrollbar.Clear(n);
            tac_scrollRect.Clear(n);
            tac_dropdown.SetDropdown(n, null);
            tac_vrcUrlInputField.SetVRCUrlInputField(n, null);
            tac_eventTrigger.SetEventTrigger(n, null);
        }

        public override void InputUse(bool value, UdonInputEventArgs args)
        {
            if (!(Utilities.IsValid(canvasCollider) && canvas.enabled)) return;

            VRCPlayerApi.TrackingData trackingData;
            if (isDesktopMode)
            {
                trackingData = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.Head);
            }
            else if (laserOnly)
            {
                if (args.handType == VRC.Udon.Common.HandType.LEFT)
                {
                    trackingData = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.LeftHand);
                }
                else
                {
                    trackingData = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.RightHand);
                }
            }
            else
            {
                return;
            }

            RaycastHit hit;
            if (Physics.Raycast(trackingData.position, trackingData.rotation * Vector3.forward, out hit, float.PositiveInfinity, ~0, QueryTriggerInteraction.Ignore))
            {
                if (Utilities.IsValid(hit) && Utilities.IsValid(hit.collider) && hit.collider.gameObject == canvasCollider.gameObject)
                {
                    if (args.boolValue)
                    {
                        SyncUIForceSetOwner(hit.point);
                        SendCallback("TAC_OnPointerDown");
                    }
                    else
                    {
                        SendCallback("TAC_OnPointerUp");
                    }
                }
            }
        }

        private void SyncUIForceSetOwner(Vector3 hitWorldPos)
        {
            GameObject hitGameObject = Raycast(hitWorldPos);
            if (Utilities.IsValid(hitGameObject))
            {
                Transform interactionUI = FindInteractionUI(hitGameObject.transform);
                Transform dragableUI = FindDragableUI(hitGameObject.transform);

                if (Utilities.IsValid(interactionUI))
                {
                    Slider slider = interactionUI.GetComponent<Slider>();
                    Scrollbar scrollbar = interactionUI.GetComponent<Scrollbar>();
                    ScrollRect scrollRect = interactionUI.GetComponent<ScrollRect>();

                    if (Utilities.IsValid(dragableUI))
                    {
                        slider = Utilities.IsValid(slider) ? slider : dragableUI.GetComponent<Slider>();
                        scrollbar = Utilities.IsValid(scrollbar) ? scrollbar : dragableUI.GetComponent<Scrollbar>();
                        scrollRect = Utilities.IsValid(scrollRect) ? scrollRect : dragableUI.GetComponent<ScrollRect>();
                    }

                    if (Utilities.IsValid(slider))
                    {
                        TACSliderSync tacSliderSync = slider.GetComponent<TACSliderSync>();
                        if (Utilities.IsValid(tacSliderSync) && tacSliderSync.enabled && !Networking.IsOwner(tacSliderSync.gameObject))
                        {
                            Networking.SetOwner(Networking.LocalPlayer, tacSliderSync.gameObject);
                        }
                    }
                    if (Utilities.IsValid(scrollbar))
                    {
                        TACScrollbarSync tacScrollbarSync = scrollbar.GetComponent<TACScrollbarSync>();
                        if (Utilities.IsValid(tacScrollbarSync) && tacScrollbarSync.enabled && !Networking.IsOwner(tacScrollbarSync.gameObject))
                        {
                            Networking.SetOwner(Networking.LocalPlayer, tacScrollbarSync.gameObject);
                        }
                    }
                    if (Utilities.IsValid(scrollRect))
                    {
                        TACScrollRectSync tacScrollRectSync = scrollRect.GetComponent<TACScrollRectSync>();
                        if (Utilities.IsValid(tacScrollRectSync) && tacScrollRectSync.enabled && !Networking.IsOwner(tacScrollRectSync.gameObject))
                        {
                            Networking.SetOwner(Networking.LocalPlayer, tacScrollRectSync.gameObject);
                        }
                        if (Utilities.IsValid(scrollRect.horizontalScrollbar) && !Networking.IsOwner(scrollRect.horizontalScrollbar.gameObject))
                        {
                            Networking.SetOwner(Networking.LocalPlayer, scrollRect.horizontalScrollbar.gameObject);
                        }
                        if (Utilities.IsValid(scrollRect.verticalScrollbar) && !Networking.IsOwner(scrollRect.verticalScrollbar.gameObject))
                        {
                            Networking.SetOwner(Networking.LocalPlayer, scrollRect.verticalScrollbar.gameObject);
                        }
                    }
                }
            }
        }

        private void OnPointerDown(int n, Vector3 pointerWorldPos)
        {
            PlayHaptics(n);

            tac_selectable.Clear(n);
            tac_toggle.Clear(n);
            tac_button.Clear(n);
            tac_slider.Clear(n);
            tac_scrollbar.Clear(n);
            tac_scrollRect.Clear(n);
            tac_dropdown.SetDropdown(n, null);
            tac_vrcUrlInputField.SetVRCUrlInputField(n, null);
            tac_eventTrigger.SetEventTrigger(n, null);
            targetTfs[n] = null;
            isDrag[n] = false;
            isFindDragableUI[n] = false;

            GameObject hitGameObject = Raycast(pointerWorldPos);
            if (Utilities.IsValid(hitGameObject))
            {
                Transform hitIrUITf = FindInteractionUI(hitGameObject.transform);

                if (Utilities.IsValid(hitIrUITf))
                {
                    RectTransform hitRTf = hitGameObject.GetComponent<RectTransform>();

                    targetTfs[n] = hitIrUITf;

                    Selectable hitSelectable = hitIrUITf.GetComponent<Selectable>();
                    tac_selectable.Init(n, hitSelectable);
                    if (Utilities.IsValid(hitSelectable))
                    {
                        tac_toggle.Init(n, hitSelectable.GetComponent<Toggle>());
                        tac_button.Init(n, hitSelectable.GetComponent<Button>());
                        tac_slider.Init(n, hitSelectable.GetComponent<Slider>(), hitGameObject, pointerWorldPos);
                        tac_scrollbar.Init(n, hitSelectable.GetComponent<Scrollbar>(), hitGameObject, pointerWorldPos);
                        tac_dropdown.SetDropdown(n, hitSelectable.GetComponent<Dropdown>());
                        tac_vrcUrlInputField.SetVRCUrlInputField(n, hitSelectable.GetComponent<VRCUrlInputField>());
                    }
                    ScrollRect hitScrollRect = hitIrUITf.GetComponent<ScrollRect>();
                    tac_scrollRect.Init(n, hitScrollRect, hitSelectable, pointerWorldPos);
                    TACEventTrigger hitEventTrigger = hitIrUITf.GetComponent<TACEventTrigger>();
                    tac_eventTrigger.SetEventTrigger(n, hitEventTrigger);

                    // OnPointerDown
                    tac_selectable.OnPointerDown(n, pointerEventData);
                    tac_eventTrigger.OnPointerDown(n);

                    // OnBeginDrag
                    Slider slider = tac_slider.GetSlider(n);
                    if (Utilities.IsValid(slider))
                    {
                        isDrag[n] = true;
                        isFindDragableUI[n] = true;

                        TACSliderSync tacSliderSync = slider.GetComponent<TACSliderSync>();
                        if (Utilities.IsValid(tacSliderSync) && tacSliderSync.enabled && !Networking.IsOwner(slider.gameObject))
                        {
                            Networking.SetOwner(Networking.LocalPlayer, slider.gameObject);
                        }
                    }
                    Scrollbar scrollbar = tac_scrollbar.GetScrollbar(n);
                    if (Utilities.IsValid(scrollbar))
                    {
                        tac_scrollbar.OnBeginDrag(n, pointerEventData);
                        isDrag[n] = true;
                        isFindDragableUI[n] = true;

                        TACScrollbarSync tacScrollbarSync = tac_scrollbar.GetScrollbar(n).GetComponent<TACScrollbarSync>();
                        if (Utilities.IsValid(tacScrollbarSync) && tacScrollbarSync.enabled && !Networking.IsOwner(tacScrollbarSync.gameObject))
                        {
                            Networking.SetOwner(Networking.LocalPlayer, tacScrollbarSync.gameObject);
                        }
                    }
                    if (Utilities.IsValid(hitScrollRect))
                    {
                        tac_scrollRect.OnBeginDrag(n, pointerEventData);
                        isDrag[n] = true;
                        isFindDragableUI[n] = true;

                        TACScrollRectSync tacScrollRectSync = hitScrollRect.GetComponent<TACScrollRectSync>();
                        if (Utilities.IsValid(tacScrollRectSync) && tacScrollRectSync.enabled && !Networking.IsOwner(hitScrollRect.gameObject))
                        {
                            Networking.SetOwner(Networking.LocalPlayer, hitScrollRect.gameObject);
                        }
                    }
                    if (Utilities.IsValid(tac_eventTrigger.GetEventTrigger(n)))
                    {
                        tac_eventTrigger.OnBeginDrag(n);
                        isDrag[n] = true;
                        isFindDragableUI[n] = true;
                    }
                }
            }

            SendCallback("TAC_OnPointerDown");
        }

        private void OnPointerUp(int n)
        {
            PlayHaptics(n);

            tac_selectable.OnPointerUp(n, pointerEventData);
            tac_eventTrigger.OnPointerUp(n);

            SendCallback("TAC_OnPointerUp");
        }

        private void OnPointerClick(int n)
        {
            tac_toggle.OnPointerClick(n, pointerEventData);
            tac_button.OnPointerClick(n, pointerEventData);
            tac_dropdown.OnPointerClick(n, pointerEventData);
            tac_vrcUrlInputField.ActivateInputField(n);
            vrcUrlActiveList.Add(n);
            SendCustomEventDelayedFrames(nameof(VRCUrlActiveInputField), 1);
            tac_eventTrigger.OnPointerClick(n);
        }

        public void VRCUrlActiveInputField()
        {
            if (vrcUrlActiveList.Count == 0) return;
            int n = vrcUrlActiveList[0].Int;
            vrcUrlActiveList.RemoveAt(0);
            tac_vrcUrlInputField.ActivateInputField(n);
        }

        private void OnBeginDrag(int n)
        {
            tac_scrollbar.OnBeginDrag(n, pointerEventData);
            tac_scrollRect.OnBeginDrag(n, pointerEventData);
            tac_eventTrigger.OnBeginDrag(n);

            Slider slider = tac_slider.GetSlider(n);
            if (Utilities.IsValid(slider))
            {
                TACSliderSync tacSliderSync = slider.GetComponent<TACSliderSync>();
                if (Utilities.IsValid(tacSliderSync) && tacSliderSync.enabled && !Networking.IsOwner(tacSliderSync.gameObject))
                {
                    Networking.SetOwner(Networking.LocalPlayer, tacSliderSync.gameObject);
                }
            }
            ScrollRect scrollRect = tac_scrollRect.GetScrollRect(n);
            if (Utilities.IsValid(scrollRect))
            {
                TACScrollRectSync tacScrollRectSync = scrollRect.GetComponent<TACScrollRectSync>();
                if (Utilities.IsValid(tacScrollRectSync) && tacScrollRectSync.enabled && !Networking.IsOwner(tacScrollRectSync.gameObject))
                {
                    Networking.SetOwner(Networking.LocalPlayer, tacScrollRectSync.gameObject);
                }
            }
        }

        private void OnDrag(int n, Vector3 pointerWorldPos)
        {
            tac_slider.OnDrag(n, pointerWorldPos, pointerEventData);
            tac_scrollbar.OnDrag(n, pointerWorldPos, pointerEventData);
            tac_scrollRect.OnDrag(n, pointerWorldPos, pointerEventData);
            tac_eventTrigger.OnDrag(n);
        }

        private void OnEndDrag(int n)
        {
            tac_scrollRect.OnEndDrag(n, pointerEventData);
            tac_eventTrigger.OnEndDrag(n);
        }

        private Transform FindInteractionUI(Transform tf)
        {
            if (!Utilities.IsValid(tf) || !tf.IsChildOf(canvas.transform)) return null;

            Selectable s = null;
            ScrollRect sr = null;
            TACEventTrigger et = null;

            while (true)
            {
                s = tf.GetComponent<Selectable>();
                if (Utilities.IsValid(s) && s.IsInteractable())
                {
                    return tf;
                }

                sr = tf.GetComponent<ScrollRect>();
                if (Utilities.IsValid(sr) && sr.enabled)
                {
                    return tf;
                }

                et = tf.GetComponent<TACEventTrigger>();
                if (Utilities.IsValid(et) && et.enabled && (et.pointerDownUB.Length > 0 || et.pointerUpUB.Length > 0 || et.pointerClickUB.Length > 0 || et.beginDragUB.Length > 0 || et.dragUB.Length > 0 || et.endDragUB.Length > 0))
                {
                    return tf;
                }

                if (tf.gameObject == canvas.gameObject) return null;

                tf = tf.parent;
            }
        }

        private Transform FindDragableUI(Transform tf)
        {
            if (!Utilities.IsValid(tf) || !tf.IsChildOf(canvas.transform)) return null;

            Slider sl = null;
            Scrollbar sb = null;
            ScrollRect sr = null;
            TACEventTrigger et = null;

            while (true)
            {
                sl = tf.GetComponent<Slider>();
                if (Utilities.IsValid(sl) && sl.enabled && sl.interactable)
                {
                    return tf;
                }

                sb = tf.GetComponent<Scrollbar>();
                if (Utilities.IsValid(sb) && sb.enabled && sb.interactable)
                {
                    return tf;
                }

                sr = tf.GetComponent<ScrollRect>();
                if (Utilities.IsValid(sr) && sr.enabled)
                {
                    return tf;
                }

                et = tf.GetComponent<TACEventTrigger>();
                if (Utilities.IsValid(et) && et.enabled && (et.beginDragUB.Length > 0 || et.dragUB.Length > 0 || et.endDragUB.Length > 0))
                {
                    return tf;
                }

                if (tf.gameObject == canvas.gameObject) return null;

                tf = tf.parent;
            }
        }

        private GameObject Raycast(Vector3 pointerPosition)
        {
            Graphic[] graphics = canvas.GetComponentsInChildren<Graphic>(false);
            graphics = SortCanvasSortingOrder(graphics);

            Vector3 worldCanvasScale = canvas.transform.lossyScale;
            for (int i = 0; i < graphics.Length; i++)
            {
                if (GraphicRaycast(graphics[i], pointerPosition, worldCanvasScale))
                {
                    return graphics[i].gameObject;
                }
            }

            return null;
        }

        private Graphic[] SortCanvasSortingOrder(Graphic[] graphics)
        {
            DataDictionary graphicsDD = emptyDataDictionaly.DeepClone();
            for (int i = 0; i < graphics.Length; i++)
            {
                int sortingOrder = graphics[i].canvas.sortingOrder;
                if (!graphicsDD.ContainsKey(sortingOrder))
                {
                    graphicsDD[sortingOrder] = new DataList();
                }
                graphicsDD[sortingOrder].DataList.Add(i);
            }
            DataList keys = graphicsDD.GetKeys();
            keys.Sort();
            keys.Reverse();
            int gIndex = 0;
            Graphic[] sorted = new Graphic[graphics.Length];
            for (int i = 0; i < keys.Count; i++)
            {
                DataList gList = graphicsDD[keys[i].Int].DataList;
                for (int j = gList.Count - 1; j >= 0; j--)
                {
                    sorted[gIndex] = graphics[gList[j].Int];
                    gIndex++;
                }
            }

            return sorted;
        }

        private bool GraphicRaycast(Graphic g, Vector3 pointerPosition, Vector3 worldCanvasScale)
        {
            if (!g.gameObject.activeInHierarchy || !g.enabled || !g.raycastTarget) return false;

            RectTransform rt = g.rectTransform;
            Rect raycastPaddingRect = calculatePaddingRect(rt, g.raycastPadding, worldCanvasScale);
            if (!raycastPaddingRect.Contains(rt.InverseTransformPoint(pointerPosition))) return false;

            var t = g.transform;

            Canvas c;
            CanvasGroup group;
            Mask mask;
            RectMask2D rectMask2D;
            Rect maskRect;

            bool ignoreParentGroups = false;
            bool continueTraversal = true;
            bool isFirst = true;

            while (Utilities.IsValid(t))
            {
                c = t.GetComponent<Canvas>();
                if (Utilities.IsValid(c) && c.overrideSorting)
                {
                    continueTraversal = false;
                }

                group = t.GetComponent<CanvasGroup>();
                if (Utilities.IsValid(group) && group.enabled)
                {
                    if (ignoreParentGroups == false && group.ignoreParentGroups)
                    {
                        ignoreParentGroups = true;
                        if (!group.blocksRaycasts) return false;
                    }
                    else if (!ignoreParentGroups)
                    {
                        if (!group.blocksRaycasts) return false;
                    }
                }

                if (!isFirst)
                {
                    mask = t.GetComponent<Mask>();
                    if (Utilities.IsValid(mask) && mask.enabled)
                    {
                        maskRect = mask.rectTransform.rect;
                        if (!maskRect.Contains(t.InverseTransformPoint(pointerPosition)))
                        {
                            return false;
                        }
                    }

                    rectMask2D = t.GetComponent<RectMask2D>();
                    if (Utilities.IsValid(rectMask2D) && rectMask2D.enabled)
                    {
                        maskRect = calculatePaddingRect(rectMask2D.rectTransform, rectMask2D.padding, worldCanvasScale);
                        if (!maskRect.Contains(t.InverseTransformPoint(pointerPosition)))
                        {
                            return false;
                        }
                    }
                }
                if (isFirst) isFirst = false;

                t = continueTraversal ? t.parent : null;
            }

            return true;
        }

        private Rect calculatePaddingRect(RectTransform rt, Vector4 padding, Vector3 worldCanvasScale)
        {
            Rect rect = rt.rect;
            Vector3 scale = rt.lossyScale;
            Vector2 factor = new Vector2(worldCanvasScale.x / scale.x, worldCanvasScale.y / scale.y);

            float left = padding.x * factor.x;
            float top = padding.y * factor.y;
            float right = padding.z * factor.x;
            float bottom = padding.w * factor.y;
            return new Rect(
                    rect.x + left,
                    rect.y + top,
                    rect.width - left - right,
                    rect.height - top - bottom
                );
        }

        private void PlayHaptics(int n)
        {
            if (!hapticFeedback) return;

            if (pointers[n].GetTouchHand() == TouchHand.LeftHand)
            {
                Networking.LocalPlayer.PlayHapticEventInHand(VRC_Pickup.PickupHand.Left, hapticDuration, hapticAmplitude, hapticFrequency);
            }
            else if (pointers[n].GetTouchHand() == TouchHand.RightHand)
            {
                Networking.LocalPlayer.PlayHapticEventInHand(VRC_Pickup.PickupHand.Right, hapticDuration, hapticAmplitude, hapticFrequency);
            }
        }

        private void SendCallback(string eventName)
        {
            foreach (UdonBehaviour ub in callbackScripts)
            {
                if (Utilities.IsValid(ub))
                {
                    ub.SendCustomEvent(eventName);
                }
            }
        }

        #region API
        public int GetPointerCount() { return pointers.Length; }

        public void GetTouch(int n, out bool isTouched, out Vector3 screenPosition, out Vector3 worldPosition)
        {
            isTouched = isPointerEntered[n];
            worldPosition = pointers[n].transform.position;
            screenPosition = canvas.transform.InverseTransformPoint(worldPosition);
        }

        public void SetLaserOnly(bool laserOnly, bool changeCanvasColliderEnabled = true)
        {
            this.laserOnly = laserOnly;
            if (changeCanvasColliderEnabled)
            {
                canvasCollider.enabled = laserOnly;
            }
        }

        public bool GetCanvasColliderEnabled()
        {
            return canvasCollider.enabled;
        }
        #endregion
    }
}