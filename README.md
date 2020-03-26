# Poshstache PowerShell module

[![Build status](https://ci.appveyor.com/api/projects/status/gbqt5h9mat4124vr?svg=true)](https://ci.appveyor.com/project/baldator/poshstache)
![Test Coverage](https://img.shields.io/badge/coverage-72%25-orange.svg?maxAge=60)
[![Poshstache](https://img.shields.io/powershellgallery/v/Poshstache.svg?style=flat-square&label=Poshstache)](https://www.powershellgallery.com/packages/Poshstache/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Module Poshstache is a Powershell implementation of Mustache.
Mustache is logic-less templates.
The module support both PowerShell Core and Windows PowerShell.

Version 0.1.2 of the module is based on the Nustache, a [.NET Mustache implementation](https://github.com/jdiamond/Nustache).
Newer versions implement Nustache for Windows Powershell version and [Stubble](https://github.com/StubbleOrg/Stubble) for PowerShell Core versions.

## Usage

Simple example with an input string and parameters:

```Powershell
Install-Module Poshstache
ConvertTo-PoshstacheTemplate -InputString "Hi {{name}}!" -ParametersObject "{name:'bob'}"
```

Applying a JSON config to a template file:

```Powershell
$jsonConfig = @"
{
key1: 'setting1',
key2: 'C:\\Logs\\'
}
"@
ConvertTo-PoshstacheTemplate -InputFile "C:\Templates\template.config" -ParametersObject $jsonConfig
```

Applying parameters from a JSON file to a template file:

```Powershell
$jsonConfigFile = "C:\Settings\config.json"
$jsonConfig = Get-Content $jsonConfigFile | Out-String
ConvertTo-PoshstacheTemplate -InputFile "C:\Templates\template.config" -ParametersObject $jsonConfig
```

Applying parameters from a JSON file to a template file and saving to a new output file in UTF8:

```Powershell
$jsonConfigFile = "C:\Settings\config.json"
$jsonConfig = Get-Content $jsonConfigFile | Out-String
ConvertTo-PoshstacheTemplate -InputFile "C:\Templates\template.config" -ParametersObject $jsonConfig | Out-File "C:\WebSite\Web.config" -Force -Encoding "UTF8"
```

## About Mustache

* [Mustache webpage](https://mustache.github.io/)
* [Mustache demo](https://mustache.github.io/#demo)
* [Mustache syntax reference](https://mustache.github.io/mustache.5.html)

## Release note
v 0.1.6 - Support complex input object \
v 0.1.5 - Add support for PowerShell Core \
v 0.1.4 - Rollback to Nustache; will create a new module for Stubble \
v 0.1.3 - Replace Nustache with Stubble \
v 0.1.2 - Bugfix \
v 0.1.1 - Add Pester tests \
v 0.1.0 - First release \
