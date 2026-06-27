
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

namespace Swingly.AvatarJson
{
    public class TagFilters : UdonSharpBehaviour
    {
        [SerializeField] PedestalManager pedestalManager;

        private void ApplyFilter(string tag)
        {
            pedestalManager.ApplyFilter(tag);
        }

        public void FilterAll()
        {
            ApplyFilter("all");
        }

        public void FilterFurry()
        {
            ApplyFilter("furry");
        }

        public void FilterHuman()
        {
            ApplyFilter("human");
        }

        public void FilterRobot()
        {
            ApplyFilter("robot");
        }
    }
}