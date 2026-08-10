
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus.CustomTouchableCanvas
{
    public enum HandFinger
    {
        None,
        LeftThumb,
        LeftIndex,
        LeftMiddle,
        LeftRing,
        LeftPinky,
        RightThumb,
        RightIndex,
        RightMiddle,
        RightRing,
        RightPinky
    }

    [DefaultExecutionOrder(1)]
    [RequireComponent(typeof(SphereCollider), typeof(Renderer))]
    [UdonBehaviourSyncMode(BehaviourSyncMode.None)]
    public class TACPointer : UdonSharpBehaviour
    {
        public HandFinger fingerType;

        private HumanBodyBones intermediate;
        private HumanBodyBones distal;

        private SphereCollider sphereCollider;
        private Renderer pointerRenderer;

        [HideInInspector] public bool isContain = false;

        void Start()
        {
            SetHumanBodyBones(fingerType);
            sphereCollider = GetComponent<SphereCollider>();
            pointerRenderer = GetComponent<Renderer>();
        }

        void Update()
        {
            bool isDesktop = Networking.LocalPlayer.IsUserInVR() == false;

            if (fingerType == HandFinger.None)
            {
                sphereCollider.enabled = isContain;
                pointerRenderer.enabled = isContain;
                isContain = false;
            }
            else
            {
                SetHumanBodyBones(fingerType);

                Vector3 index2 = Networking.LocalPlayer.GetBonePosition(intermediate);
                Vector3 index3 = Networking.LocalPlayer.GetBonePosition(distal);

                bool isFingerError = false;
                if (index2 == Vector3.zero && index3 == Vector3.zero)
                {
                    TouchHand touchHand = GetTouchHand();
                    if (touchHand == TouchHand.LeftHand)
                    {
                        transform.position = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.LeftHand).position;
                    }
                    else if (touchHand == TouchHand.RightHand)
                    {
                        transform.position = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.RightHand).position;
                    }
                    else
                    {
                        isFingerError = true;
                    }
                }
                else
                {
                    transform.position = Vector3.LerpUnclamped(index2, index3, 1.8f);
                }

                sphereCollider.enabled = !isDesktop && !isFingerError && isContain;
                pointerRenderer.enabled = !isDesktop && !isFingerError && isContain;
                isContain = false;
            }
        }

        public void SetFingerType(HandFinger finger)
        {
            fingerType = finger;
            SetHumanBodyBones(fingerType);
        }

        public HandFinger GetFingerType()
        {
            return fingerType;
        }

        public TouchHand GetTouchHand()
        {
            switch (fingerType)
            {
                case HandFinger.LeftThumb:
                case HandFinger.LeftMiddle:
                case HandFinger.LeftIndex:
                case HandFinger.LeftRing:
                case HandFinger.LeftPinky:
                    return TouchHand.LeftHand;
                case HandFinger.RightThumb:
                case HandFinger.RightMiddle:
                case HandFinger.RightIndex:
                case HandFinger.RightRing:
                case HandFinger.RightPinky:
                    return TouchHand.RightHand;
                default:
                    return TouchHand.None;
            }
        }

        private void SetHumanBodyBones(HandFinger fingerType)
        {
            if (fingerType != HandFinger.None)
            {
                switch (fingerType)
                {
                    case HandFinger.LeftThumb:
                        intermediate = HumanBodyBones.LeftThumbIntermediate;
                        distal = HumanBodyBones.LeftThumbDistal;
                        break;
                    case HandFinger.LeftIndex:
                        intermediate = HumanBodyBones.LeftIndexIntermediate;
                        distal = HumanBodyBones.LeftIndexDistal;
                        break;
                    case HandFinger.LeftMiddle:
                        intermediate = HumanBodyBones.LeftMiddleIntermediate;
                        distal = HumanBodyBones.LeftMiddleDistal;
                        break;
                    case HandFinger.LeftRing:
                        intermediate = HumanBodyBones.LeftRingIntermediate;
                        distal = HumanBodyBones.LeftRingDistal;
                        break;
                    case HandFinger.LeftPinky:
                        intermediate = HumanBodyBones.LeftLittleIntermediate;
                        distal = HumanBodyBones.LeftLittleDistal;
                        break;
                    case HandFinger.RightThumb:
                        intermediate = HumanBodyBones.RightThumbIntermediate;
                        distal = HumanBodyBones.RightThumbDistal;
                        break;
                    case HandFinger.RightIndex:
                        intermediate = HumanBodyBones.RightIndexIntermediate;
                        distal = HumanBodyBones.RightIndexDistal;
                        break;
                    case HandFinger.RightMiddle:
                        intermediate = HumanBodyBones.RightMiddleIntermediate;
                        distal = HumanBodyBones.RightMiddleDistal;
                        break;
                    case HandFinger.RightRing:
                        intermediate = HumanBodyBones.RightRingIntermediate;
                        distal = HumanBodyBones.RightRingDistal;
                        break;
                    case HandFinger.RightPinky:
                        intermediate = HumanBodyBones.RightLittleIntermediate;
                        distal = HumanBodyBones.RightLittleDistal;
                        break;
                }
            }
        }
    }
}