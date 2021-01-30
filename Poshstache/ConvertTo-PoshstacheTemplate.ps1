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
    .PARAMETER ValidJSON
        Switch to determine if boolean true value in JSON input has to be converted to PowerShell $true (default) or 'true' (switch present)
    .PARAMETER HashTable
        Switch to determine if the imput object is a PowerShell Hashtable ($true)
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
        [psobject] $ParametersObject,
        [Switch] $ValidJSON = $false,
        [Switch] $HashTable = $false
    )

    if($PSCmdlet.ParameterSetName -eq "File"){
        if (-not (Test-Path $InputFile)) {
            Throw "Input file doesn't exist"
        }
        $InputString = Get-Content $InputFile -Raw
    }
    $path = Get-ModulePath "Poshstache"

    #Check if input object is valid
    Write-Verbose "Input object is HashTable: $HashTable"
    if($HashTable){
        $JSONObject = $ParametersObject | ConvertTo-Json -Depth 4
        Write-Verbose "Object converted to JSON: $JSONObject"
        Write-Verbose $JSONObject.gettype()
    }
    else{
        $JSONObject = $ParametersObject
    }

    try {
        if($PSversiontable.psversion.Major -lt 6){
            $JSonInput = ConvertFrom-JsonToHashtable $JSONObject
        }
        else{
            $JSonInput = ConvertFrom-Json $JSONObject -asHashtable
        }
    }
    catch{
        Throw $_
    }

    if($ValidJSON){
        $JSonInput = ConvertTo-ValidJson $JSonInput
    }

    Write-verbose "Input object: $JSonInput"

    if($PSversiontable.psversion.Major -lt 6){
        $libPath = "$Path\binary\WindowsPowerShell"
        # Add .net dependencies
        Add-Type -Path "$libPath\System.Collections.Immutable.dll"
    }
    else{
		$libPath = "$Path\binary"
	}

	# Load Stubble dll
	Add-Type -Path "$libPath\System.Threading.Tasks.Extensions.dll"

	try{
		Add-Type -Path "$libPath\Stubble.Core.dll"
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