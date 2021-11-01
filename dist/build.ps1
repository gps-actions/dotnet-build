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

        & apt-get update;
        & apt-get upgrade -y;
        Invoke-WebRequest "https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb" -OutFile packages-microsoft-prod.deb
        & dpkg -i packages-microsoft-prod.deb
        Remove-Item packages-microsoft-prod.deb

        & apt-get update;
        & apt-get install -y apt-transport-https;
        & apt-get update;
        & apt search dotnet-sdk-6.0;
        & apt-get install -y dotnet-sdk-6.0;

        $dotnet = (Get-Command dotnet -ErrorAction Stop).Source

        Write-Host "${dotnet}"

        & $dotnet --version
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
