# Poshstache PowerShell module

[![Build status](https://ci.appveyor.com/api/projects/status/gbqt5h9mat4124vr?svg=true)](https://ci.appveyor.com/project/baldator/poshstache)

Module Poshstache is a Powershell implementation of Mustache.
Mustache is logic-less templates.

This module is based on the .NET Mustache implementation (https://github.com/jdiamond/Nustache)


# Usage

```Powershell
Install-Module Poshstache
ConvertTo-PoshstacheTemplate -InputString "Hi {{name}}!" -ParametersObject "{name:'bob'}"
```

# About Mustache

* Mustache webpage: https://mustache.github.io/
* Mustache demo: https://mustache.github.io/#demo
* Mustache syntax reference: https://mustache.github.io/mustache.5.html
