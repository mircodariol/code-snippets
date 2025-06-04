<#
.SYNOPSIS
    Retrieves user logon events from the Windows Security event log for a specified date.

.DESCRIPTION
    This script queries the Windows Security event log for logon events (Event ID 4624) within a specified date.
    It maps logon type IDs to human-readable names and outputs relevant information about each logon event.

.PARAMETER TargetDate
    The date (in yyyy-MM-dd format) for which to retrieve logon events. Defaults to today's date if not specified.

.EXAMPLE
    .\Get-LogonEvents.ps1 -TargetDate "2024-06-01"

    Retrieves all user logon events for June 1, 2024.

.EXAMPLE
    .\Get-LogonEvents.ps1 | Where-Object { $_.LogonTypeId -eq "2" } | Format-Table -AutoSize -RepeatHeader

    Retrieves all user logon events (interactive) of today.

.NOTES
    Author: Mirco Dariol
    Date:   2025-06-04
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$TargetDate = (Get-Date).ToString("yyyy-MM-dd") # Default to today's date if not provided
)

# The scripts requires administrative privileges to access the Security event log
# Check if the script is running with elevated privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script requires administrative privileges. Please run it as an administrator."
    exit 1
}

# Declare a mapping for logon types
$logonTypeMap = @{
    "2" = "Interactive"
    "3" = "Network"
    "4" = "Batch"
    "5" = "Service"
    "7" = "Unlock"
    "8" = "NetworkCleartext"
    "9" = "NewCredentials"
    "10" = "RemoteInteractive"
    "11" = "CachedInteractive"
}

$fromDate = Get-Date $TargetDate  # Convert the input string to a DateTime object
if (-not $fromDate) {
    Write-Error "Invalid date format. Please provide a valid date."
    exit 1
}
$toDate = $fromDate.AddDays(1)

Write-Host "Searching for user logon events between $($fromDate.ToString("yyyy-MM-dd")) and $($toDate.ToString("yyyy-MM-dd")) ..."

# Get logon events from the Security windows event security log
$logonEvents = 
Get-WinEvent -FilterHashtable @{
    LogName = 'Security';
    ID = 4624;
    StartTime = $fromDate;
    EndTime = $toDate;
} | ForEach-Object {
    $xml = [xml]$_.ToXml()
    $logonType = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "LogonType" } | Select-Object -ExpandProperty '#text'
    $userName = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "TargetUserName" } | Select-Object -ExpandProperty '#text'

    if ($logonType -in $logonTypeMap.Keys) {
        [PSCustomObject]@{
            TimeCreated = $_.TimeCreated
            UserName = $userName
            LogonTypeId = "$logonType"
            LogonType = "$($logonTypeMap[$logonType])"
        }
    }
}

return $logonEvents
