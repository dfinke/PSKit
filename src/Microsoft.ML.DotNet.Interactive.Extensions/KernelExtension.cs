// Copyright (c) .NET Foundation and contributors. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System.Threading.Tasks;
using Microsoft.DotNet.Interactive;
using Microsoft.DotNet.Interactive.Formatting;

namespace Microsoft.ML.DotNet.Interactive
{
    public class MlKernelExtension : IKernelExtension
    {
        public Task OnLoadAsync(IKernel kernel)
        {
            Formatter<DecisionTreeData>.Register((tree, writer) =>
            {
                writer.Write(DecisionTreeDataFormatting.GenerateTreeView(tree));
            }, "text/html");

            return Task.CompletedTask;
        }
    }
}
