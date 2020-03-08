// Copyright (c) .NET Foundation and contributors. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System.CommandLine;
using System.CommandLine.Invocation;
using System.IO;
using System.Threading.Tasks;
using Microsoft.DotNet.Interactive;
using Microsoft.DotNet.Interactive.Commands;
using Microsoft.DotNet.Interactive.Events;
using Microsoft.DotNet.Interactive.Formatting;

namespace Microsoft.Data.Analysis.Interactive
{
    public class DataFrameKernelExtension : IKernelExtension
    {
        public Task OnLoadAsync(IKernel kernel)
        {
            //Formatter<DataFrame>.Register((tree, writer) =>
            //{
            //    writer.Write("");
            //}, "text/html");

            var kernelBase = kernel as KernelBase;
            var directive = new Command("#!doit")
            {
                Handler = CommandHandler.Create(async (FileInfo csv, string typeName, KernelInvocationContext context) =>
                {
                    // do the job
                    var command = new SubmitCode(@$"public class {typeName}{{}}");
                    context.Publish(new DisplayedValueProduced($"emitting {typeName} from {csv.FullName}", context.Command));
                    await context.HandlingKernel.SendAsync(command);
                })
            };

            directive.AddOption(new Option<FileInfo>(
                "csv").ExistingOnly());

            directive.AddOption(new Option<string>(
                "typeName",
                getDefaultValue:() => "Foo"));

            kernelBase.AddDirective(directive);
            
            return Task.CompletedTask;

        }
    }
}
