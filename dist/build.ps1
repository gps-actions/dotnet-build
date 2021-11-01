#!pwsh

$rootPath = $env:BUILD_ROOT_PATH
$configuration = $env:BUILD_CONFIGURATION
$platform = $env:BUILD_PLATFORM
[switch]$restore = [System.Convert]::ToBoolean($env:BUILD_RESTORE)

Write-Host "`$rootPath: $rootPath"
Write-Host "`$configuration: $configuration"
Write-Host "`$platform: $platform"
Write-Host "`$restore: $restore"

if(Test-Path $rootPath) {
    #download Dotnet
    # Run a separate PowerShell process because the script calls exit, so it will end the current PowerShell session.
    &powershell -NoProfile -ExecutionPolicy unrestricted `
        -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; " + `
            "&([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://dot.net/v1/dotnet-install.ps1'))) " + `
            "-Channel 6.0 -Quality prerelease -Os linux -InstallDir ./dotnet"

    $env:PATH += ":./dotnet"

    $dotnet=Get-Command dotnet

    Write-Host "${dotnet.Source}"
}
else {
    & ls -al
    throw "BUILD_ROOT_PATH ($rootPath) does not exist."
}