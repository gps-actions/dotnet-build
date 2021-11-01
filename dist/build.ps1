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

}
else {
    throw "BUILD_ROOT_PATH ($rootPath) does not exist."
}