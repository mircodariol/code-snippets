<#
.SYNOPSIS
    This script checks the Authenticode signatures of files in a specified directory.

.DESCRIPTION
    The script recursively scans a directory for files with .exe, .dll, and .ps1 extensions.
    It retrieves the Authenticode signature of each file and collects details of valid signatures.

.PARAMETER path
    The path to the directory to scan for files.

.EXAMPLE
    .\Get-AuthentiCodeSignatures.ps1 -path "C:\path\to\directory"

    This command will scan the specified directory for files with .exe, .dll, and .ps1 extensions and display the details of valid signatures.

.EXAMPLE
    .\Get-AuthentiCodeSignatures.ps1 -path "C:\path\to\directory" | Export-Csv -Path "C:\path\to\output.csv" -NoTypeInformation

    This command will scan the specified directory for files with .exe, .dll, and .ps1 extensions and export the details of valid signatures to a CSV file.

.EXAMPLE
    .\Get-AuthentiCodeSignatures.ps1 -Path "C:\path\to\directory" | Select-Object -Property SubjectName -Unique 

    This command will scan the specified directory for files with .exe, .dll, and .ps1 extensions and display the unique SubjectName of valid signatures found.

.EXAMPLE
    .\Get-AuthentiCodeSignatures.ps1 -Path "C:\path\to\directory" | Where-Object { $_.SubjectName -like "*Microsoft*" }

    This command will scan the specified directory for files with .exe, .dll, and .ps1 extensions and display the details of valid signatures with SubjectName containing "Microsoft".

.EXAMPLE
    .\Get-AuthentiCodeSignatures.ps1 -Path "C:\path\to\directory" | Group-Object -Property SubjectName

    This command will scan the specified directory for files with .exe, .dll, and .ps1 extensions and group the details of valid signatures by SubjectName.

.EXAMPLE 
    .\Get-AuthentiCodeSignatures.ps1 -Path "C:\path\to\directory" | Where-Object {$_.Thumbprint -eq "B9BC5E843979BF65A61713BE439D1409F60F6688"

    This command will scan the specified directory for files with .exe, .dll, and .ps1 extensions and display the details of valid signatures with Thumbprint equals to "B9BC5E843979BF65A61713BE439D1409F60F6688".

.NOTES
    Author: Mirco Dariol
    Date: March 14, 2025
#>

[CmdletBinding()]
param (
    [string]$path
)

# Get all files in the directory
$files = Get-ChildItem -Path $path -File -Recurse

$signedFiles = @()
# Loop through each file and get the certificate details
foreach ($file in $files) {
    try {
        # Update the progress bar
        $percentComplete = [math]::Round(($files.IndexOf($file) / $files.Count) * 100)
        Write-Progress -Activity "$($percentComplete)% Checking signatures" -Status "Processing file: $($file.FullName)" -PercentComplete $percentComplete

        # Skip not PE files
        if ($file.Extension -ne '.exe' -and $file.Extension -ne '.dll' -and $file.Extension -ne '.ps1') {
            continue
        }

        # Get the Authenticode signature
        $signature = Get-AuthenticodeSignature -FilePath $file.FullName
        if ($signature.Status -eq 'Valid') {
            # Get the signature certificate
            $certificate = $signature.SignerCertificate

            # Grab the details
            $signedFiles += [PSCustomObject]@{
                FileName     = $file.Name
                FilePath     = $file.FullName
                SubjectName  = $certificate.Subject
                Issuer       = $certificate.Issuer
                StartDate    = $certificate.NotBefore
                ExpireDate   = $certificate.NotAfter
                SerialNumber = $certificate.SerialNumber
                Thumbprint   = $certificate.Thumbprint
            }
        }
    }
    catch {
        Write-Warning "Failed to get certificate for file: $($file.FullName)"
    }
}

return $signedFiles
