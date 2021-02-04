$ModuleName   = "Poshstache"
$ModulePath = "$PSScriptRoot\..\$ModuleName\$ModuleName.psm1"

Import-module $ModulePath -Force

Describe 'ConvertTo-PoshstacheTemplate' {

    Context 'Poshstache Input String' {

        It "throw if input is empty" {
            {
                ConvertTo-PoshstacheTemplate -InputString -ParametersObject "{testParam:12}"

            } | Should Throw
        }

        It "throw if InputObject is not a valid JSON - Invalid Value" {
            {
                ConvertTo-PoshstacheTemplate -InputString "TestString" -ParametersObject "{testParam:121a}"
            } | Should Throw
        }

        It "throw if InputObject is not a valid JSON - Invalid Format" {
            {
                ConvertTo-PoshstacheTemplate -InputString "TestString" -ParametersObject "{testParam:121}a"
            } | Should Throw
        }


        It "Valid JSON input - Should not Throw" {
            {
                ConvertTo-PoshstacheTemplate -InputString "TestString" -ParametersObject "{testParam:121}"
                ConvertTo-PoshstacheTemplate -InputString "Hi {{testParam}}!" -ParametersObject "{testParam:121}"
                ConvertTo-PoshstacheTemplate -InputString "Hi {{testParam.name}}!" -ParametersObject "{testParam:{name:121}}"
            } | Should Not Throw
        }

        It "Valid hashTable input - Should not Throw" {
            {
                ConvertTo-PoshstacheTemplate -InputString "TestString" -ParametersObject @{"testParam" = 121} -hashTable
                ConvertTo-PoshstacheTemplate -InputString "Hi {{testParam}}!" -ParametersObject @{"testParam" = 121} -hashTable
                ConvertTo-PoshstacheTemplate -InputString "Hi {{testParam.name}}!" -ParametersObject @{"testParam" = @{"name" = 121}} -hashTable
            } | Should Not Throw
        }
    }

    Context 'Poshstache Input File format' {

        It "throw if file is empty" {
            {
                ConvertTo-PoshstacheTemplate -InputFile -ParametersObject "{testParam:12}"

            } | Should Throw
        }

        It "throw if file doen't exist" {
            {
                ConvertTo-PoshstacheTemplate -InputFile .\assets\templateNotExisting.html -ParametersObject "{testParam:12}"

            } | Should Throw
        }

        It "throw if InputObject is not a valid JSON - Invalid Value" {
            {
                $inputString = Get-Content "$PSScriptRoot\..\Tests\assets\invalid.js" -Raw
                ConvertTo-PoshstacheTemplate -InputFile "$PSScriptRoot\..\Tests\assets\templateSimple.html" -ParametersObject $inputString
            } | Should Throw
        }

        It "Valid JSON input - Should not Throw" {
            {
                $inputString = Get-Content "$PSScriptRoot\..\Tests\assets\validSimple.js" -Raw
                ConvertTo-PoshstacheTemplate -InputFile "$PSScriptRoot\..\Tests\assets\templateSimple.html" -ParametersObject $inputString
            } | Should not Throw
        }

        It "Valid JSON input - Array Template" {
            {
                $inputString = Get-Content "$PSScriptRoot\..\Tests\assets\validArray.js" -Raw
                ConvertTo-PoshstacheTemplate -InputFile "$PSScriptRoot\..\Tests\assets\validArray_template.html" -ParametersObject $inputString
            } | Should not Throw
        }

        It "Valid JSON input - Array Template containing objects" {
            {
                $inputString = Get-Content "$PSScriptRoot\..\Tests\assets\validArrayObject.js" -Raw
                ConvertTo-PoshstacheTemplate -InputFile "$PSScriptRoot\..\Tests\assets\validArrayObject_template.html" -ParametersObject $inputString
            } | Should not Throw
        }
    }


    Context 'Poshstache Input File values' {

        It "Valid JSON input" {
            $resultValue = "<h1>Hi Powershell!</h1>"
            $inputString = Get-Content "$PSScriptRoot\..\Tests\assets\validSimple.js" -Raw
            $result = ConvertTo-PoshstacheTemplate -InputFile "$PSScriptRoot\..\Tests\assets\templateSimple.html" -ParametersObject $inputString
            $result | Should Be $resultValue
        }

        It "Valid JSON input - Array Template" {
            $result = "<p>John is 30 years old. He has the following cars:
    <ul>
        <li>Ford</li>
        <li>BMW</li>
        <li>Fiat</li>
    </ul>
</p>"
            $resultOneLine = $result -replace '\r*\n', ''
            $inputString = Get-Content "$PSScriptRoot\..\Tests\assets\validArray.js" -Raw
            $result = ConvertTo-PoshstacheTemplate -InputFile "$PSScriptRoot\..\Tests\assets\validArray_template.html" -ParametersObject $inputString
            $result = $result  -replace '\r*\n', ''
            $result | Should Be $resultOneLine
        }

        It "Valid hashTable input - Array Template" {
            $result = "<p>John is 30 years old. He has the following cars:
    <ul>
        <li>Ford</li>
        <li>BMW</li>
        <li>Fiat</li>
    </ul>
</p>"
            $resultOneLine = $result -replace '\r*\n', ''
            $result = ConvertTo-PoshstacheTemplate -InputFile "$PSScriptRoot\..\Tests\assets\validArray_template.html" -ParametersObject @{"name"= 'John'; "cars" = @("Ford","BMW","Fiat");"age"=30} -hashTable
            $result = $result  -replace '\r*\n', ''
            $result | Should Be $resultOneLine
        }

        It "Valid hashTable input - Array Template with PS boolean" {
            $result = "<p>John is 30 years old. Driving licence: true. He has the following cars:
    <ul>
        <li>Ford</li>
        <li>BMW</li>
        <li>Fiat</li>
    </ul>
</p>"
            $resultOneLine = $result -replace '\r*\n', ''
            $result = ConvertTo-PoshstacheTemplate -InputFile "$PSScriptRoot\..\Tests\assets\validArray_template.html" -ParametersObject @{"name"= 'John'; "cars" = @("Ford","BMW","Fiat");"age"=30; "drivingLicence" = $true} -hashTable -validJSON
            $result = $result  -replace '\r*\n', ''
            $result | Should Be $resultOneLine
        }

        It "Valid hashTable input - Array Template with PS boolean" {
            $result = "<p>John is 30 years old. Driving licence: `$true. He has the following cars:
    <ul>
        <li>Ford</li>
        <li>BMW</li>
        <li>Fiat</li>
    </ul>
</p>"
            $resultOneLine = $result -replace '\r*\n', ''
            $result = ConvertTo-PoshstacheTemplate -InputFile "$PSScriptRoot\..\Tests\assets\validArray_template.html" -ParametersObject @{"name"= 'John'; "cars" = @("Ford","BMW","Fiat");"age"=30; "drivingLicence" = $true} -hashTable
            $result = $result  -replace '\r*\n', ''
            $result | Should Be $resultOneLine
        }

        It "Valid JSON input - Array Template containing objects" {
            $result = "<p>John is 30 years old. He has the following cars:
    <ul>
        <li>Ford</li><li>BMW</li><li>Fiat</li>
    </ul>
</p>"
            $resultOneLine = $result -replace '\r*\n', ''
            $inputString = Get-Content "$PSScriptRoot\..\Tests\assets\validArrayObject.js" -Raw
            $result = ConvertTo-PoshstacheTemplate -InputFile "$PSScriptRoot\..\Tests\assets\validArrayObject_template.html" -ParametersObject $inputString
            $result = $result  -replace '\r*\n', ''
            $result | Should Be $resultOneLine
        }

        It "Complex Mustache template conversion" {
            $result =  @"
"Account_enabled": {
    "value": true
}
"@
            $resultOneLine = $result -replace '\r*\n', ''
            $inputString = Get-Content "$PSScriptRoot\..\Tests\assets\complexTemplate.js" -Raw
            $result = ConvertTo-PoshstacheTemplate -InputFile "$PSScriptRoot\..\Tests\assets\complexTemplate.txt" -ParametersObject $inputString
            $result = $result  -replace '\r*\n', ''
            $result | Should Be $resultOneLine

        }
    }
}