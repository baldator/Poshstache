function Get-ModulePath{
    param(
        [Parameter(Mandatory=$true)]
        [String]
        $Name
    )

    $module = Get-Module $Name
    if (-not $module){
        Throw "Module does not exist"
    }

    return $(Get-item $module.path).Directory.FullName
}