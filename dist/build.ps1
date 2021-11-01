#!pwsh

$rootPath = $env:BUILD_ROOT_PATH
$configuration = $env:BUILD_CONFIGURATION
$platform = $env:BUILD_PLATFORM
[switch]$restore = [System.Convert]::ToBoolean($env:BUILD_RESTORE)

Write-Host "`$rootPath: $rootPath"
Write-Host "`$configuration: $configuration"
Write-Host "`$platform: $platform"
Write-Host "`$restore: $restore"

try {
    if (Test-Path $rootPath) {
        #download Dotnet
        # Run a separate PowerShell process because the script calls exit, so it will end the current PowerShell session.
        # $parameters = '-Channel 6.0 -Quality preview -InstallDir ./dotnet -Architecture x64 -Verbose';
        # & pwsh -NoProfile -ExecutionPolicy unrestricted `
        #     -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; &([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing 'https://dot.net/v1/dotnet-install.ps1'))) $parameters" 

        & apt-get update -qq > /dev/null;
        & apt-get upgrade -y -qq > /dev/null;
        & apt-get install apt-utils -y -qq > /dev/null;
        Invoke-WebRequest "https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb" -OutFile packages-microsoft-prod.deb
        & apt install ./packages-microsoft-prod.deb -y -qq > /dev/null
        Remove-Item packages-microsoft-prod.deb

        & apt-get update -qq > /dev/null;
        & apt-get install -y apt-transport-https -qq > /dev/null;
        & apt-get update -qq > /dev/null;
        & apt search dotnet-sdk-5.0 -qq > /dev/null;
        & apt-get install -y dotnet-sdk-5.0 -qq > /dev/null;

        $dotnet = (Get-Command dotnet -ErrorAction Stop).Source

        Push-Location

        Set-Location $rootPath

        & $dotnet build --configuration $configuration --arch $platform
    }
    else {
        & ls -al
        throw "BUILD_ROOT_PATH ($rootPath) does not exist."
    }
}
catch {
    $error
    throw $error
}
