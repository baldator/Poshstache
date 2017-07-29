$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3

# Load functions
$functions = Get-ChildItem -Path $PSScriptRoot -Recurse -Include *.ps1
$functions | ForEach-Object { . $_.FullName }