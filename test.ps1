$ModuleName = "Poshstache"
$SrcRootDir  = "$PSScriptRoot\$ModuleName"
$CodeCoverageEnabled = $true
$TestRootDir = "$PSScriptRoot\Tests"
$CodeCoverageFiles = "$SrcRootDir\*.ps1", "$SrcRootDir\*.psm1"

if (!(Get-Module Pester -ListAvailable)) {
    "Pester module is not installed. Skipping $($psake.context.currentTaskName) task."
    return
}

Import-Module Pester

try {
    Microsoft.PowerShell.Management\Push-Location -LiteralPath $TestRootDir

    if ($TestOutputFile) {
        $testing = @{
            OutputFile   = $TestOutputFile
            OutputFormat = $TestOutputFormat
            PassThru     = $true
            Verbose      = $VerbosePreference
        }
    }
    else {
        $testing = @{
            PassThru     = $true
            Verbose      = $VerbosePreference
        }
    }

    # To control the Pester code coverage, a boolean $CodeCoverageEnabled is used.
    if ($CodeCoverageEnabled) {
        $testing.CodeCoverage = $CodeCoverageFiles
    }

    $testResult = Invoke-Pester @testing

    Assert -conditionToCheck (
        $testResult.FailedCount -eq 0
    ) -failureMessage "One or more Pester tests failed, build cannot continue."

    if ($CodeCoverageEnabled) {
        $testCoverage = [int]($testResult.CodeCoverage.NumberOfCommandsExecuted /
                                $testResult.CodeCoverage.NumberOfCommandsAnalyzed * 100)
        "Pester code coverage on specified files: ${testCoverage}%"
    }
}
finally {
    Microsoft.PowerShell.Management\Pop-Location
    Remove-Module $ModuleName -ErrorAction SilentlyContinue
}