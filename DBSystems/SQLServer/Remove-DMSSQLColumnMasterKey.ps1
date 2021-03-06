#Requires -Version 5.0
#Requires -Modules SQLServer

<#
.SYNOPSIS
    Removes the column master key object from the database

.DESCRIPTION

.NOTES
    This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
    The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
    The terms of use for ScriptRunner do not apply to this script. In particular, AppSphere AG assumes no liability for the function, 
    the use and the consequences of the use of this freely available script.
    PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of AppSphere AG.
    © AppSphere AG

.COMPONENT
    Requires Module SQLServer
    Requires the library script DMSSqlServer.ps1
    
.LINK
    https://github.com/scriptrunner/ActionPacks/blob/master/DBSystems/SQLServer
 
.Parameter ServerInstance
    Specifies the name of the target computer including the instance name, e.g. MyServer\Instance 

.Parameter ServerCredential
    Specifies a PSCredential object for the connection to the SQL Server. ServerCredential is ONLY used for SQL Logins. 
    When you are using Windows Authentication you don't specify -Credential. It is picked up from your current login.

.Parameter DatabaseName 
    Specifies the SQL database object for runs the operation

.Parameter KeyName
    Specifies the name of the column master key object that this cmdlet creates

.Parameter ConnectionTimeout
    Specifies the time period to retry the command on the target server
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true)]   
    [string]$ServerInstance,    
    [Parameter(Mandatory = $true)]   
    [string]$DatabaseName,            
    [Parameter(Mandatory = $true)]   
    [string]$KeyName,
    [pscredential]$ServerCredential,
    [int]$ConnectionTimeout = 30
)

Import-Module SQLServer

try{
    $instance = GetSQLServerInstance -ServerInstance $ServerInstance -ServerCredential $ServerCredential -ConnectionTimeout $ConnectionTimeout

    $dbInstance = GetSqlDatabase -DatabaseName $DatabaseName -ServerInstance $instance
    
    $null = Remove-SqlColumnMasterKey -InputObject $dbInstance -Name $KeyName -ErrorAction Stop
    
    if($SRXEnv) {
        $SRXEnv.ResultMessage = "Key $($KeyName) successfully removed"
    }
    else{
        Write-Output "Key $($KeyName) successfully removed"
    }
}
catch{
    throw
}
finally{
}