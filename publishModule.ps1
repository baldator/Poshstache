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

$moduleFolderPath = "$env:APPVEYOR_BUILD_FOLDER\PoshtachePublish"
$null = mkdir $moduleFolderPath
Get-ChildItem -Path $env:APPVEYOR_BUILD_FOLDER/Release/Poshstache | Copy-Item -Destination $moduleFolderPath

## Publish module to PowerShell Gallery
$publishParams = @{
    Path = $moduleFolderPath
    NuGetApiKey = $env:nuget_apikey
    Repository = 'PSGal<lery'
    Force = $true
    Confirm = $false
}
Publish-Module @publishParams
