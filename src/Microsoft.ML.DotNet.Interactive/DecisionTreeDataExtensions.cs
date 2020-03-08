// Copyright (c) .NET Foundation and contributors. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System;
using System.Linq;
using System.Text;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers.FastTree;

namespace Microsoft.ML.DotNet.Interactive
{
    public static class DecisionTreeDataExtensions
    {
        public static DecisionTreeData ToDecisionTreeData(this RegressionTreeEnsemble ensemble,in VBuffer<ReadOnlyMemory<char>> featureNames = default)
        {
            // just get the first tree, for now
            return ensemble.Trees.FirstOrDefault().ToDecisionTreeData(featureNames);
        }

        public static DecisionTreeData ToDecisionTreeData(this RegressionTree tree, in VBuffer<ReadOnlyMemory<char>> featureNames = default)
        {
            DecisionTreeData treeData = new DecisionTreeData();

            if (tree == null)
            {
                return treeData;
            }

            var nodes = new NodeData[tree.NumberOfNodes];
            var labelBuilder = new StringBuilder();
            for (int node = 0; node < tree.NumberOfNodes; node++)
            {
                nodes[node] = new NodeData();
                int featureIndex = tree.NumericalSplitFeatureIndexes[node];
                float splitThreshold = tree.NumericalSplitThresholds[node];

                ReadOnlyMemory<char> featureName = featureNames.GetItemOrDefault(featureIndex);
                if (!featureName.IsEmpty)
                {
                    labelBuilder.Append(featureName);
                }
                else
                {
                    labelBuilder.Append('f');
                    labelBuilder.Append(featureIndex);
                }
                labelBuilder.Append($" > ");
                labelBuilder.Append(splitThreshold.ToString("n2"));

                nodes[node].Label = labelBuilder.ToString();
                labelBuilder.Clear();
            }

            NodeData[] leaves = new NodeData[tree.NumberOfLeaves];
            for (int leaf = 0; leaf < tree.NumberOfLeaves; leaf++)
            {
                leaves[leaf] = new NodeData {Label = tree.LeafValues[leaf].ToString("n2")};
            }

            NodeData GetNodeData(int child)
            {
                return child >= 0
                    ? nodes[child]
                    : leaves[~child];
            }

            // hook the nodes up
            for (int node = 0; node < tree.NumberOfNodes; node++)
            {
                // the RightChild is the 'greater than' path, so put that first
                nodes[node].Children.Add(GetNodeData(tree.RightChild[node]));
                nodes[node].Children.Add(GetNodeData(tree.LeftChild[node]));
            }

            if (nodes.Length > 0)
            {
                treeData.Root = nodes[0];
            }

            return treeData;
        }
    }
}
