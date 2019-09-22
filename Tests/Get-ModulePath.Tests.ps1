$ModuleName   = "Poshstache"
$ModulePath = "$PSScriptRoot\..\$ModuleName\$ModuleName.psm1"

Import-module $ModulePath -Force

Describe 'Get-ModulePath' {
    Context 'Test module exists' {
        It "throw if Module doesn't exist" {
            {
                Get-ModulePath -Name DummyModule

            } | Should Throw
        }

        It "don't throw if Module doesn't exist" {
            {
                Get-ModulePath -Name Poshstache

            } | Should Not Throw
        }
    }
}