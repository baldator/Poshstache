$ErrorActionPreference = "Stop"

$moduleName = "Poshstache"
$provParams = @{
    Name = 'NuGet'
    MinimumVersion = '2.8.5.208'
    Force = $true
}

$null = Install-PackageProvider @provParams
$null = Import-PackageProvider @provParams

Install-Module -Name PowerShellGet -Force -Confirm:$false
Remove-Module -Name PowerShellGet -Force -ErrorAction Ignore
Import-Module -Name PowerShellGet

$localModule = Import-module "$env:APPVEYOR_BUILD_FOLDER\Release\$moduleName\$moduleName.psd1" -force
$localModule = Get-module $moduleName
$remoteModule = Find-Module $moduleName
$moduleFolderPath = "$env:APPVEYOR_BUILD_FOLDER\Release\$moduleName"

## Publish module to PowerShell Gallery
$publishParams = @{
    Path = $moduleFolderPath
    NuGetApiKey = $env:nuget_apikey
    Repository = 'PSGallery'
    Force = $true
    Confirm = $false
}

Write-output "Local version: ${localModule.version}"
Write-output "Remote version: ${remoteModule.version}"

if ($localModule.version -gt $remoteModule.version){
    Publish-Module @publishParams
}
Else{
    Write-output "No need to publish the module"
}

