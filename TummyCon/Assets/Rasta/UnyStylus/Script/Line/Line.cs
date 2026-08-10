
using System;
using UdonSharp;
using UnityEngine;
using VRC.SDK3.Data;
using VRC.SDKBase;
using VRC.Udon;

namespace Rasta.UnyStylus
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.NoVariableSync)]
    public class Line : UdonSharpBehaviour
    {

        public int playerId;
        public int lineId;
        public Color color = Color.white;
        public float width = 0;

        private LineRenderer lineRenderer;
        private MeshCollider meshCollider;

        private DataDictionary chunkLengthDict = new DataDictionary();

        public void Init(int playerId, int lineId, Color color, float width, Material pcMaterial, Material mobileMaterial, Material pcSelectedMaterial, Material mobileSelectedMaterial)
        {
            this.playerId = playerId;
            this.lineId = lineId;

            lineRenderer = GetComponent<LineRenderer>();
            meshCollider = transform.GetChild(0).GetComponent<MeshCollider>();

            lineRenderer.startColor = color;
            lineRenderer.endColor = color;
            this.color = color;

            this.width = width;
#if UNITY_STANDALONE
            lineRenderer.material = pcMaterial;
            lineRenderer.material.SetFloat("_Width", width);
#else
            lineRenderer.material = mobileMaterial;
            lineRenderer.widthMultiplier = width;
            lineRenderer.numCapVertices = 10;
#endif
        }

        public void SetLine(int chunkId, Vector3[] positions)
        {
            if (positions.Length == 0) return;

            int targetIndex = 0;
            DataList chunkIds = chunkLengthDict.GetKeys();
            for (int i = 0; i < chunkIds.Count; i++)
            {
                if (chunkIds[i].Int < chunkId)
                {
                    targetIndex += chunkLengthDict[chunkIds[i]].Int;
                }
            }

            Vector3[] lrPositions = new Vector3[lineRenderer.positionCount];
            lineRenderer.GetPositions(lrPositions);
            if (chunkLengthDict.ContainsKey(chunkId))
            {
                lrPositions = RemovePositions(lrPositions, targetIndex, chunkLengthDict[chunkId].Int);
            }
            chunkLengthDict[chunkId] = positions.Length;

            lrPositions = InsertPositions(lrPositions, targetIndex, positions);
            lineRenderer.positionCount = lrPositions.Length;
            lineRenderer.SetPositions(lrPositions);

            float previousWidth = lineRenderer.widthMultiplier;
            lineRenderer.widthMultiplier = width;
            Mesh mesh = new Mesh();
            lineRenderer.BakeMesh(mesh, true);
            meshCollider.sharedMesh = mesh;
            lineRenderer.widthMultiplier = previousWidth;
        }

        private Vector3[] RemovePositions(Vector3[] positions, int index, int length)
        {
            Vector3[] _positions = new Vector3[positions.Length - length];
            Array.Copy(positions, 0, _positions, 0, index);
            Array.Copy(positions, index + length, _positions, index, _positions.Length - index);
            return _positions;
        }

        private Vector3[] InsertPositions(Vector3[] positions, int index, Vector3[] insertPositions)
        {
            Vector3[] _positions = new Vector3[positions.Length + insertPositions.Length];
            Array.Copy(positions, 0, _positions, 0, index);
            Array.Copy(insertPositions, 0, _positions, index, insertPositions.Length);
            Array.Copy(positions, index, _positions, index + insertPositions.Length, positions.Length - index);
            return _positions;
        }
    }
}
