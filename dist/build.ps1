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

        $env:PATH=""

        $env:DOTNET_INSTALL_DIR="/dotnet"
        Invoke-WebRequest 'https://dot.net/v1/dotnet-install.ps1' -OutFile ./dotnet-install.ps1 -Verbose

        . ./dotnet-install.ps1 -Channel 6.0 -Quality preview -InstallDir $env:DOTNET_INSTALL_DIR -Architecture x64 -Verbose

        if($LASTEXITCODE -ne 0){
            throw "Powershell returned $LASTEXITCODE installing dotnet.";
        }

        $env:PATH += ':./dotnet'

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
