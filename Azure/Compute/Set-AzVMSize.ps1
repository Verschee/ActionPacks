﻿#Requires -Version 5.0
#Requires -Modules Az.Compute

<#
    .SYNOPSIS
        Sets virtual machine size
    
    .DESCRIPTION  
        
    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, AppSphere AG assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of AppSphere AG.
        © AppSphere AG

    .COMPONENT
        Requires Module Az
        Requires Library script AzureAzLibrary.ps1

    .LINK
        https://github.com/scriptrunner/ActionPacks/blob/master/Azure        

    .Parameter AzureCredential
        The PSCredential object provides the user ID and password for organizational ID credentials, or the application ID and secret for service principal credentials

    .Parameter Tenant
        Tenant name or ID

    .Parameter Name
        Specifies the name of the virtual machine

    .Parameter Size
        Specifies the new size of the virtual machine

    .Parameter ResourceGroupName
        Specifies the name of the resource group of the virtual machine
#>

param( 
    [Parameter(Mandatory = $true)]
    [pscredential]$AzureCredential,
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [Parameter(Mandatory = $true)]
    [ValidateSet('Standard_DS1_v2','Standard_DS2_v2','Standard_DS3_v2','Standard_DS4_v2','Standard_DS5_v2')]
    [string]$Size,
    [string]$Tenant
)

Import-Module Az

try{
#    ConnectAzure -AzureCredential $AzureCredential -Tenant $Tenant

    $vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $Name -ErrorAction Stop
    $vm.HardwareProfile.VmSize = $Size

    Stop-AzVM -ResourceGroupName $ResourceGroupName -Name $Name -Force -ErrorAction Stop
    Update-AzVM -VM $vm -ResourceGroupName $ResourceGroupName -ErrorAction Stop
    Start-AzVM -ResourceGroupName $ResourceGroupName -Name $Name -ErrorAction Stop

    $ret = Get-AzVMSize -ResourceGroupName $ResourceGroupName -VMName $Name -ErrorAction Stop

    if($SRXEnv) {
        $SRXEnv.ResultMessage = $ret 
    }
    else{
        Write-Output $ret
    }
}
catch{
    throw
}
finally{
#    DisconnectAzure -Tenant $Tenant
}