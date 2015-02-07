param(
    [string]$target = "Build",
    [string]$verbosity = "minimal",
    [int]$maxCpuCount = 0
)

$msbuilds = @(get-command msbuild -ea SilentlyContinue)
if ($msbuilds.Count -gt 0) {
    $msbuild = $msbuilds[0].Definition
}
else {
    if (test-path "env:\ProgramFiles(x86)") {
        $path = join-path ${env:ProgramFiles(x86)} "MSBuild\12.0\bin\MSBuild.exe"
        if (test-path $path) {
            $msbuild = $path
        }
    }
    if ($msbuild -eq $null) {
        $path = join-path $env:ProgramFiles "MSBuild\12.0\bin\MSBuild.exe"
        if (test-path $path) {
            $msbuild = $path
        }
    }
    if ($msbuild -eq $null) {
        throw "MSBuild could not be found in the path. Please ensure MSBuild v12 (from Visual Studio 2013) is in the path."
    }
}

if ($maxCpuCount -lt 1) {
    $maxCpuCountText = $Env:MSBuildProcessorCount
} else {
    $maxCpuCountText = ":$maxCpuCount"
}

$allArgs = @("visualstudio.xunit.proj", "/m$maxCpuCountText", "/nologo", "/verbosity:$verbosity", "/t:$target", $args)
& $msbuild $allArgs
