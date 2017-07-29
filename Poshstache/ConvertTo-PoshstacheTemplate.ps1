function ConvertTo-PoshstacheTemplate{
    param(
        [Parameter(ParameterSetName='String',Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String] $InputString,
        [Parameter(ParameterSetName='File',Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String] $InputFile,
        [Parameter(ParameterSetName='File',Mandatory=$true)]
        [Parameter(ParameterSetName='String',Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String] $ParametersObject
    )

    if($PSCmdlet.ParameterSetName -eq "File"){
        if (-not (Test-Path $InputFile)) {
            Throw "Input file doesn't exist"
        }
        $InputString = Get-Content $InputFile -Raw
    }

    #Check if input object is valid
    try {
        $JsonInput = ConvertFrom-JsonToHashtable $ParametersObject
    } catch {
        Throw "The input ParametersObject is not a valid JSON string"
    }

    #Load Nustache dll
    $path = Get-ModulePath "Poshstache"
    [Reflection.Assembly]::LoadFile("$Path\binary\Nustache.Core.dll") | Out-Null
    try{
        return [Nustache.Core.Render]::StringToString($InputString, $JsonInput)
    } catch [Exception] {
        $_.Exception.Message
    }
}