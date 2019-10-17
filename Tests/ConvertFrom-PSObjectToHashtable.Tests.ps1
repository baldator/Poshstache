$ModuleName   = "Poshstache"
$ModulePath = "$PSScriptRoot\..\$ModuleName\$ModuleName.psm1"

Import-module $ModulePath -Force


InModuleScope $ModuleName {
    Describe 'ConvertFrom-PSObjectToHashtable' {

        Context 'Null input' {

            It "Should return null" {
                ConvertFrom-PSObjectToHashtable -InputObject $null | Should BeNullOrEmpty
            }
        }

        Context 'Valid input'{
            It 'Conversion Not Null'{
                $obj = New-Object -TypeName psobject
                $obj | Add-Member -MemberType NoteProperty -Name firstname -Value 'Prateek'
                $obj | Add-Member -MemberType NoteProperty -Name lastname -Value 'Singh'
                ConvertFrom-PSObjectToHashtable -InputObject $obj | Should Not BeNullOrEmpty
            }

            It 'Conversion is valid'{
                $obj = New-Object -TypeName psobject
                $obj | Add-Member -MemberType NoteProperty -Name firstname -Value 'Prateek'
                $obj | Add-Member -MemberType NoteProperty -Name lastname -Value 'Singh'
            }

            It 'Multilevel conversion is valid'{
                $obj = New-Object -TypeName psobject
                $obj | Add-Member -MemberType NoteProperty -Name firstname -Value 'Prateek'
                $obj | Add-Member -MemberType NoteProperty -Name lastname -Value 'Singh'
                $obj2 = New-Object -TypeName psobject
                $obj2 | Add-Member -MemberType NoteProperty -Name street -Value '1st street'
                $obj2 | Add-Member -MemberType NoteProperty -Name city -Value 'NYC'
                $obj | Add-Member -MemberType NoteProperty -Name address -Value $obj2

            }
        }
    }
}