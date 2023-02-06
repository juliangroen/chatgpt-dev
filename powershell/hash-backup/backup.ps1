#!/usr/bin/env pwsh
param(
  [string]$file
)

$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$logFile = "$file.log"

while ($true) {
  try {
    $currentHash = [System.BitConverter]::ToString(
      $md5.ComputeHash([System.IO.File]::ReadAllBytes($file))
    ).Replace("-", "")
    Start-Sleep -Seconds 1

    $newHash = [System.BitConverter]::ToString(
      $md5.ComputeHash([System.IO.File]::ReadAllBytes($file))
    ).Replace("-", "")
    if ($currentHash -ne $newHash) {
      $existingBackups = Get-ChildItem "$file.backup*"
      $nextNumber = 1
      foreach ($existingBackup in $existingBackups) {
        if ($existingBackup.Name -match "backup(\d+)$") {
          $existingBackupNumber = [int]$matches[1]
          if ($existingBackupNumber -ge $nextNumber) {
            $nextNumber = $existingBackupNumber + 1
          }
        }
      }
      Copy-Item $file "$file.backup$nextNumber"
      $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
      $message = "${timestamp}: Backup created: $file.backup$nextNumber"
      Write-Output $message
      Add-Content $logFile $message
    }
  } catch {
    Write-Error "An error occurred while accessing the file: $_"
  }
}
