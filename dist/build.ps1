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
    Invoke-WebRequest https://dot.net/v1/dotnet-install.sh -OutFile ./dotnet-install.sh
    & chmod +x dotnet-install.sh

    /bin/bash ./dotnet-install.sh --channel 6.0.1xx --quality preview --install-dir ./dotnet --os linux --runtime dotnet

    $dotnet=Get-Command dotnet

    Write-Host "${dotnet.Source}"
}
else {
    & ls -al
    throw "BUILD_ROOT_PATH ($rootPath) does not exist."
}