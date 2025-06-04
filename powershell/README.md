# PowerShell Scripts

- [PowerShell Scripts](#powershell-scripts)
  * [Get-AuthentiCodeSignatures.ps1](#get-authenticodesignaturesps1)
    + [Scope](#scope-1)
    + [Usage](#usage-1)
      - [Prerequisites](#prerequisites-1)
      - [Parameters](#parameters-1)
      - [Example](#example)
  * [Get-LogonEvents.ps1](#get-logoneventsps1)
    + [Scope](#scope)
    + [Usage](#usage)
      - [Prerequisites](#prerequisites)
      - [Parameters](#parameters)
      - [Examples](#examples)
      - [Output](#output)

## Get-AuthentiCodeSignatures.ps1

This script checks the Authenticode signatures of files in a specified directory.

### Scope

This script recursively scans a directory for files with `.exe`, `.dll`, and `.ps1` extensions. It retrieves the Authenticode signature of each file and collects details of valid signatures.

### Usage

#### Prerequisites

- PowerShell 5.1 or later is recommended.

#### Parameters

- `path`: The path to the directory to scan for files.

#### Example

**This command will scan the specified directory for files with .exe, .dll, and .ps1 extensions and display the details of valid signatures.**

```powershell
.\Get-AuthentiCodeSignatures.ps1 -path "C:\path\to\directory"
```

**This command will scan the specified directory for files with .exe, .dll, and .ps1 extensions and export the details of valid signatures to a CSV file.**

```powershell
.\Get-AuthentiCodeSignatures.ps1 -path "C:\path\to\directory" | Export-Csv -Path "C:\path\to\output.csv" -NoTypeInformation
```
    
**This command will scan the specified directory for files with .exe, .dll, and .ps1 extensions and display the unique SubjectName of valid signatures found.**

```powershell
.\Get-AuthentiCodeSignatures.ps1 -Path "C:\path\to\directory" | Select-Object -Property SubjectName -Unique 
```

**This command will scan the specified directory for files with .exe, .dll, and .ps1 extensions and display the details of valid signatures with SubjectName containing "Microsoft".**

```powershell
.\Get-AuthentiCodeSignatures.ps1 -Path "C:\path\to\directory" | Where-Object { $_.SubjectName -like "*Microsoft*" }
```

**This command will scan the specified directory for files with .exe, .dll, and .ps1 extensions and group the details of valid signatures by SubjectName.**
```powershell
.\Get-AuthentiCodeSignatures.ps1 -Path "C:\path\to\directory" | Group-Object -Property SubjectName
```    

**This command will scan the specified directory for files with .exe, .dll, and .ps1 extensions and display the details of valid signatures with Thumbprint equals to "B9BC5E843979BF65A61713BE439D1409F60F6688".**
```powershell
.\Get-AuthentiCodeSignatures.ps1 -Path "C:\path\to\directory" | Where-Object {$_.Thumbprint -eq "B9BC5E843979BF65A61713BE439D1409F60F6688"
```

## Get-LogonEvents.ps1

### Scope

The `Get-LogonEvents.ps1` PowerShell script retrieves user logon events from the Windows Security event log for a specified date. It focuses on Event ID 4624 (successful logons) and maps logon type IDs to descriptive names (e.g., Interactive, Network, Service). This script is intended for system administrators and auditors who need to review user logon activity on a Windows system.

**Features:**
- Queries logon events for a specific date (defaults to today if not specified).
- Maps logon type IDs to human-readable names.
- Outputs timestamp, username, logon type ID, and logon type name.
- Requires administrative privileges to access the Security event log.

### Usage

#### Prerequisites

- Run the script with administrative privileges.
- PowerShell 5.1 or later is recommended.

#### Parameters

- `-TargetDate` (optional): The date for which to retrieve logon events, in `yyyy-MM-dd` format. Defaults to today's date if not provided.

#### Examples

**Retrieve all logon events for June 1, 2024:**
```powershell
.\Get-LogonEvents.ps1 -TargetDate "2024-06-01"
```

**Retrieve all interactive logon events for today and display in a table:**
```powershell
.\Get-LogonEvents.ps1 | Where-Object { $_.LogonTypeId -eq "2" } | Format-Table -AutoSize -RepeatHeader
```

#### Output

The script returns a list of objects with the following properties:
- `TimeCreated` — The timestamp of the logon event.
- `UserName` — The account name used for the logon.
- `LogonTypeId` — The numeric logon type.
- `LogonType` — The descriptive logon type (e.g., Interactive, Network).

> **Note:**  
> You must run this script as an administrator to access the Security event log.
