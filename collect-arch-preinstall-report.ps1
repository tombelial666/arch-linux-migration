# Run on the LAPTOP in PowerShell (Admin): .\collect-arch-preinstall-report.ps1
$ErrorActionPreference = 'Continue'
$ReportDir = $PSScriptRoot
$Report = Join-Path $ReportDir 'arch-preinstall-report.txt'

"=== $(Get-Date) ===" | Out-File $Report -Encoding utf8
"Machine: $env:COMPUTERNAME" | Out-File $Report -Append -Encoding utf8

"--- SYSTEM ---" | Out-File $Report -Append -Encoding utf8
systeminfo | Out-File $Report -Append -Encoding utf8
Get-ComputerInfo | Select-Object CsName, WindowsVersion, OsHardwareAbstractionLayer, CsManufacturer, CsModel, BiosManufacturer, BiosVersion, BiosReleaseDate, CsProcessors, OsTotalVisibleMemorySize | Format-List | Out-File $Report -Append -Encoding utf8

"--- DISKS ---" | Out-File $Report -Append -Encoding utf8
Get-Disk | Format-Table -AutoSize | Out-File $Report -Append -Encoding utf8
Get-Partition | Format-Table -AutoSize | Out-File $Report -Append -Encoding utf8
Get-Volume | Format-Table -AutoSize | Out-File $Report -Append -Encoding utf8

"--- BITLOCKER ---" | Out-File $Report -Append -Encoding utf8
try {
    Get-BitLockerVolume | Format-List | Out-File $Report -Append -Encoding utf8
} catch {
    "BitLocker: $($_.Exception.Message)" | Out-File $Report -Append -Encoding utf8
}

"--- FIRMWARE ---" | Out-File $Report -Append -Encoding utf8
try {
    Confirm-SecureBootUEFI 2>&1 | Out-File $Report -Append -Encoding utf8
} catch {
    "SecureBoot check: $($_.Exception.Message)" | Out-File $Report -Append -Encoding utf8
}

"--- GPU / NET / AUDIO (PnP) ---" | Out-File $Report -Append -Encoding utf8
Get-PnpDevice -PresentOnly | Where-Object { $_.Class -match 'Display|Net|Bluetooth|Camera|Audio|Biometric' } | Format-Table -AutoSize | Out-File $Report -Append -Encoding utf8

"--- BATTERY ---" | Out-File $Report -Append -Encoding utf8
$batHtml = Join-Path $ReportDir 'battery-report.html'
powercfg /batteryreport /output $batHtml 2>&1 | Out-File $Report -Append -Encoding utf8

"--- LARGE USER FOLDERS ---" | Out-File $Report -Append -Encoding utf8
$paths = @(
    $env:USERPROFILE,
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Pictures",
    "$env:USERPROFILE\.ssh",
    "$env:USERPROFILE\.gitconfig"
)
foreach ($p in $paths) {
    if (Test-Path $p) {
        $sum = (Get-ChildItem $p -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        if ($null -eq $sum) { $sum = 0 }
        "$p : $([math]::Round($sum / 1GB, 2)) GB" | Out-File $Report -Append -Encoding utf8
    }
}

"--- INSTALLED APPS (winget) ---" | Out-File $Report -Append -Encoding utf8
$wingetJson = Join-Path $ReportDir 'winget-packages.json'
try {
    winget export -o $wingetJson 2>&1 | Out-File $Report -Append -Encoding utf8
} catch {
    "winget export: $($_.Exception.Message)" | Out-File $Report -Append -Encoding utf8
}

Write-Host "Report: $Report"
Write-Host "Battery: $batHtml"
