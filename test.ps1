####################
# Variables
####################

$ModuleName = "Poshstache"
$SrcRootDir  = "$PSScriptRoot\$ModuleName"
$CodeCoverageEnabled = $true
$TestRootDir = "$PSScriptRoot\Tests"
$CodeCoverageFiles = "$SrcRootDir\*.ps1", "$SrcRootDir\*.psm1"
$TestOutputFile = "$PSScriptRoot\TestsResults.xml"
$TestOutputFormat = "NUnitXml"

####################
# Functions
####################

function Update-CodeCoveragePercent {
    [cmdletbinding(supportsshouldprocess)]
    param(
        [int]
        $CodeCoverage = 0,

        [string]
        $TextFilePath = "$PSScriptRoot\README.md"
    )

    $BadgeColor = switch ($CodeCoverage) {
        {$_ -in 90..100} { 'brightgreen' }
        {$_ -in 75..89}  { 'yellow' }
        {$_ -in 60..74}  { 'orange' }
        default          { 'red' }
    }

    if ($PSCmdlet.ShouldProcess($TextFilePath)) {
        $ReadmeContent = (Get-Content $TextFilePath)
        $ReadmeContent = $ReadmeContent -replace "!\[Test Coverage\].+\)", "![Test Coverage](https://img.shields.io/badge/coverage-$CodeCoverage%25-$BadgeColor.svg?maxAge=60)"
        $ReadmeContent | Set-Content -Path $TextFilePath
    }
}

#################

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

    if($testResult.FailedCount -ne 0){
        Write-error "One or more Pester tests failed, build cannot continue."
        exit 1
    }

    if ($CodeCoverageEnabled) {
        $testCoverage = [int]($testResult.CodeCoverage.NumberOfCommandsExecuted /
                                $testResult.CodeCoverage.NumberOfCommandsAnalyzed * 100)
        "Pester code coverage on specified files: ${testCoverage}%"
        Update-CodeCoveragePercent -CodeCoverage $testCoverage
    }

    if($TestOutputFile){
        $wc = New-Object 'System.Net.WebClient'
        $wc.UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path $TestOutputFile))
    }
}
finally {
    Microsoft.PowerShell.Management\Pop-Location
    Remove-Module $ModuleName -ErrorAction SilentlyContinue
}