﻿#Requires -Version 4.0

<#
    .SYNOPSIS
        Connect to Microsoft Exchange Server and removes the Universal distribution group
    
    .DESCRIPTION  

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, AppSphere AG assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of AppSphere AG.
        © AppSphere AG

    .COMPONENT       
        ScriptRunner Version 4.x or higher

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/Exchange/DistributionGroups

    .Parameter GroupName
        Specifies the Name, Alias, Display name, Distinguished name, Guid or Mail address of the Universal distribution group to which to remove
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$GroupName
)

#Clear
    try{
        Remove-DistributionGroup -Identity $GroupName -Confirm:$false -ErrorAction Stop       
        if($SRXEnv) {
            $SRXEnv.ResultMessage = "Universal distribution group $($GroupName) removed"
        } 
        else{    
            Write-Output = "Universal distribution group $($GroupName) removed"
        }
    }
    Finally{

    }
