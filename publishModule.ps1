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

$moduleFolderPath = "$env:APPVEYOR_BUILD_FOLDER\Poshstache"

## Publish module to PowerShell Gallery
$publishParams = @{
    Path = $moduleFolderPath
    NuGetApiKey = $env:nuget_apikey
    Repository = 'PSGallery'
    Force = $true
    Confirm = $false
}
Publish-Module @publishParams
