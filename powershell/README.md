# PowerShell Scripts

- [PowerShell Scripts](#powershell-scripts)  
  * [Get-AuthentiCodeSignatures.ps1](#get-authenticodesignaturesps1)
    + [Scope](#scope-1)
    + [Usage](#usage-1)
      - [Prerequisites](#prerequisites-1)
      - [Parameters](#parameters-1)
      - [Example](#example)

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
