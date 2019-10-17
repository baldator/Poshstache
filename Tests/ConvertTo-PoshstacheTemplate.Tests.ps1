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
    }

    Context 'Poshstache Input File' {

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
}