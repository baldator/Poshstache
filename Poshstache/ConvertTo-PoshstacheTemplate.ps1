function ConvertTo-PoshstacheTemplate{
    <#
	.SYNOPSIS
		Mustache implementation. Mustache is logic-less templates.
	.DESCRIPTION
        Convert a template plus an input object into an output file.
    .PARAMETER InputString
        A string containing the template
    .PARAMETER InputFile
        The path of the file containing the template
    .PARAMETER ParametersObject
        A JSON String containing mustache parameters
    .EXAMPLE
        ConvertTo-PoshstacheTemplate -InputString "Hi {{name}}!" -ParameterObject @{name:'bob'}
    .EXAMPLE
        ConvertTo-PoshstacheTemplate -InputFile .\myInputFile.txt -ParameterObject @{name:'bob'}
	#>
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
    $path = Get-ModulePath "Poshstache"

    #Check if input object is valid
    try {
        if($PSversiontable.psversion.Major -lt 6){
            [Reflection.Assembly]::LoadFile("$path\binary\Newtonsoft.Json.dll") | Out-Null
            $JSonInput = [Newtonsoft.Json.Linq.JObject]::Parse($ParametersObject)
        }
        else{
            $JSonInput = ConvertFrom-Json $ParametersObject -asHashtable
        }
    }
    catch{
        Throw $_
    }

    if($PSversiontable.psversion.Major -lt 6){
        #Load Nustache dll
        [Reflection.Assembly]::LoadFile("$Path\binary\Nustache.Core.dll") | Out-Null
        try{
            return [Nustache.Core.Render]::StringToString($InputString, $JsonInput)
        } catch [Exception] {
            $_.Exception.Message
        }
    }
    else{
        # Load Stubble dll
        Add-Type -Path "$Path\binary\System.Threading.Tasks.Extensions.dll"

        try{
            Add-Type -Path "$Path\binary\Stubble.Core.dll" -ReferencedAssemblies "System.Threading.Tasks.Extensions"
        }
        catch{
            $_.Exception.LoaderExceptions
            {
                Throw $_
            }
        }

        try{
            $builder = [Stubble.Core.Builders.StubbleBuilder]::new().Build()
            return $builder.render($InputString, $JsonInput)
        } catch [Exception] {
            $_.Exception.Message
        }
    }
}
