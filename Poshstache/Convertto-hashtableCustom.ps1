#requires -version 2.0


Function Convertto-hashtableCustom {

<#
.Synopsis
Convert an object into a hashtable.
.Description
This command will take an object and create a hashtable based on its properties.
You can have the hashtable exclude some properties as well as properties that
have no value.
.Parameter Inputobject
A PowerShell object to convert to a hashtable.
.Parameter NoEmpty
Do not include object properties that have no value.
.Parameter Exclude
An array of property names to exclude from the hashtable.
.Example
PS C:\> get-process -id $pid | select name,id,handles,workingset | ConvertTo-HashTable

Name                           Value
----                           -----
WorkingSet                     418377728
Name                           powershell_ise
Id                             3456
Handles                        958
.Example
PS C:\> $hash = get-service spooler | ConvertTo-Hashtable -Exclude CanStop,CanPauseandContinue -NoEmpty
PS C:\> $hash

Name                           Value
----                           -----
ServiceType                    Win32OwnProcess, InteractiveProcess
ServiceName                    spooler
ServiceHandle                  SafeServiceHandle
DependentServices              {Fax}
ServicesDependedOn             {RPCSS, http}
Name                           spooler
Status                         Running
MachineName                    .
RequiredServices               {RPCSS, http}
DisplayName                    Print Spooler

This created a hashtable from the Spooler service object, skipping empty
properties and excluding CanStop and CanPauseAndContinue.
.Notes
Version:  2.0
Updated:  January 17, 2013
Author :  Jeffery Hicks (http://jdhitsolutions.com/blog)

Read PowerShell:
Learn Windows PowerShell 3 in a Month of Lunches
Learn PowerShell Toolmaking in a Month of Lunches
PowerShell in Depth: An Administrator's Guide

 "Those who forget to script are doomed to repeat their work."

.Link
http://jdhitsolutions.com/blog/2013/01/convert-powershell-object-to-hashtable-revised
.Link
About_Hash_Tables
Get-Member
.Inputs
Object
.Outputs
hashtable
#>

[cmdletbinding()]

Param(
[Parameter(Position=0,Mandatory=$True,
HelpMessage="Please specify an object",ValueFromPipeline=$True)]
[ValidateNotNullorEmpty()]
[object]$InputObject,
[switch]$NoEmpty,
[string[]]$Exclude
)

Process {
    #get type using the [Type] class because deserialized objects won't have
    #a GetType() method which is what we would normally use.

    $TypeName = [system.type]::GetTypeArray($InputObject).name
    Write-Verbose "Converting an object of type $TypeName"

    #get property names using Get-Member
    $names = $InputObject | Get-Member -MemberType properties |
    Select-Object -ExpandProperty name

    #define an empty hash table
    $hash = @{}

    #go through the list of names and add each property and value to the hash table
    $names | ForEach-Object {
        #only add properties that haven't been excluded
        if ($Exclude -notcontains $_) {
            #only add if -NoEmpty is not called and property has a value
            if ($NoEmpty -AND -Not ($inputobject.$_)) {
                Write-Verbose "Skipping $_ as empty"
            }
            else {
                Write-Verbose "Adding property $_"
                $hash.Add($_,$inputobject.$_)
        }
        } #if exclude notcontains
        else {
            Write-Verbose "Excluding $_"
        }
    } #foreach
        Write-Verbose "Writing the result to the pipeline"
        Write-Output $hash
 }#close process

}#end function