Describe 'Poshstache Manifest' {
    
    $ModuleName   = "Poshstache"
    $ManifestPath = "$PSScriptRoot\..\$ModuleName\$ModuleName.psd1"

    Context 'Validation' {

        $Script:Manifest = $Script:Manifest = Test-ModuleManifest -Path $ManifestPath

        It "has a valid manifest" {
            {
                Test-ModuleManifest -Path $ManifestPath -ErrorAction Stop -WarningAction SilentlyContinue        
            } | Should Not Throw
        }

        It "has a valid name in the manifest" {
            $Script:Manifest.Name | Should Be $ModuleName
        }

        It 'has a valid root module' {
            $Script:Manifest.RootModule | Should Be "$ModuleName.psm1"
        }

        It "has a valid version in the manifest" {
            $Script:Manifest.Version -as [Version] | Should Not BeNullOrEmpty
        }
    
        It 'has a valid description' {
            $Script:Manifest.Description | Should Not BeNullOrEmpty
        }

        It 'has a valid author' {
            $Script:Manifest.Author | Should Not BeNullOrEmpty
        }
    
        It 'has a valid guid' {
            { 
                [guid]::Parse($Script:Manifest.Guid) 
            } | Should Not throw
        }
    
        It 'has a valid copyright' {
            $Script:Manifest.CopyRight | Should Not BeNullOrEmpty
        }        
    }   
}