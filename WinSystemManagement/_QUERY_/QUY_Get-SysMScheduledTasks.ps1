#Requires -Version 4.0

<#
.SYNOPSIS
    Retrieves the scheduled tasks that is registered on the computer

.DESCRIPTION

.NOTES
    This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
    The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
    The terms of use for ScriptRunner do not apply to this script. In particular, AppSphere AG assumes no liability for the function, 
    the use and the consequences of the use of this freely available script.
    PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of AppSphere AG.
    © AppSphere AG

.COMPONENT

.LINK
    https://github.com/scriptrunner/ActionPacks/tree/master/WinSystemManagement/_QUERY_

.Parameter ComputerName
    Specifies the name of the computer from which to retrieve the schedule tasks.
    
.Parameter AccessAccount
    Specifies a user account that has permission to perform this action. If Credential is not specified, the current user account is used.
#>

[CmdLetBinding()]
Param(
    [string]$ComputerName,
    [PSCredential]$AccessAccount
)

try{
    $Script:Cim=$null
    if([System.String]::IsNullOrWhiteSpace($ComputerName)){
        $ComputerName=[System.Net.DNS]::GetHostByName('').HostName
    }          
    if($null -eq $AccessAccount){
        $Script:Cim =New-CimSession -ComputerName $ComputerName -ErrorAction Stop
    }
    else {
        $Script:Cim =New-CimSession -ComputerName $ComputerName -Credential $AccessAccount -ErrorAction Stop
    }
    if($SRXEnv) {
        $SRXEnv.ResultList =@()
        $SRXEnv.ResultList2 =@()
    }
    $Script:Tasks = Get-ScheduledTask -CimSession $Script:Cim | Select-Object TaskName,TaskPath | Sort-Object -Property TaskName
    foreach($item in $Script:Tasks)
    {
        if($SRXEnv) {
            $SRXEnv.ResultList += $item.TaskName
            $SRXEnv.ResultList2 += "$($item.TaskName) ($($item.TaskPath))" # Display
        }
        else{
            Write-Output "$($item.TaskName) ($($item.TaskPath))"
        }
    }
}
catch{
    throw
}
finally{
    if($null -ne $Script:Cim){
        Remove-CimSession $Script:Cim 
    }
}