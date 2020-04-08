function ConvertTo-ValidJson
{
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )

    process
    {
        if ($null -eq $InputObject) { return $null }


        if($InputObject -is [Array]){
            for ($counter=0; $counter -lt $InputObject.Length; $counter++){
                $InputObject[$counter] = ConvertTo-ValidJson $InputObject[$counter]
            }

            return $InputObject
        }
        elseif ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string])
        {
            $tmpHash = @{}
            foreach ($key in $InputObject.keys){
                $tmpHash[$key] = ConvertTo-ValidJson $InputObject[$key]
            }

            return $tmpHash

        }
        elseif ($InputObject -is [psobject])
        {
            foreach ($property in $InputObject.PSObject.Properties)
            {
                $name = $property.Name
                $InputObject."$name" = ConvertTo-ValidJson $property.Value
            }

            return $InputObject
        }
        elseif ($InputObject -is [Boolean])
        {
            return $InputObject.ToString().ToLower()
        }
        else
        {
            return $InputObject
        }
    }
}