// Copyright Matthias Koch 2017.
// Distributed under the MIT License.
// https://github.com/nuke-build/nuke/blob/master/LICENSE

using System;
using System.IO;
using System.Linq;
using Nuke.Core;
using Nuke.Core.Tooling;

namespace Nuke.Common.Tools.NuGet
{
    [Serializable]
    public class NuGetSettings : ToolSettings
    {
        public override string ToolPath =>
                base.ToolPath
                ?? ToolPathResolver.TryGetEnvironmentExecutable("NUGET_EXE")
                ?? Path.Combine(NukeBuild.Instance.TemporaryDirectory, "nuget.exe");
    }
}
