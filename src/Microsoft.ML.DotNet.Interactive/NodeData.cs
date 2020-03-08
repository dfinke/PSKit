// Copyright (c) .NET Foundation and contributors. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System.Collections.Generic;

namespace Microsoft.ML.DotNet.Interactive
{
    public class NodeData
    {
        public string Label { get; set; }
        public float Data { get; set; }
        public float Value { get; set; }
        public List<NodeData> Children { get; } = new List<NodeData>();
    }
}
