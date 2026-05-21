# Backup editor/remote configs. Obsidian Vault is on GitHub (obsidian-git), not copied here.
# Usage: .\backup-to-main-pc.ps1 -Destination "Z:\backup-laptop-arch"
param(
    [Parameter(Mandatory = $true)]
    [string]$Destination
)

$ErrorActionPreference = 'Continue'
$stamp = Get-Date -Format 'yyyy-MM-dd-HHmm'
$root = Join-Path $Destination "laptop-backup-$stamp"
New-Item -ItemType Directory -Force -Path $root | Out-Null

function Copy-IfExists($src, $rel) {
    if (Test-Path $src) {
        $dst = Join-Path $root $rel
        if (Test-Path $src -PathType Leaf) {
            New-Item -ItemType Directory -Force -Path (Split-Path $dst -Parent) -ErrorAction SilentlyContinue | Out-Null
            Copy-Item -Path $src -Destination $dst -Force -ErrorAction SilentlyContinue
        } else {
            Copy-Item -Path $src -Destination $dst -Recurse -Force -ErrorAction SilentlyContinue
        }
        Write-Host "OK: $src"
    } else {
        Write-Host "SKIP: $src"
    }
}

Write-Host "Backup root: $root"

# Editor / remote (Vault → see Git remote obsidian, skip local copy)
Copy-IfExists "$env:USERPROFILE\.gitconfig" "gitconfig\.gitconfig"
Copy-IfExists "$env:APPDATA\Cursor" "cursor-appdata"
Copy-IfExists "$env:APPDATA\Code\User" "vscode-user"
Copy-IfExists "$env:ProgramData\Tailscale" "tailscale-programdata"
Copy-IfExists "$env:LOCALAPPDATA\Tailscale" "tailscale-local"
Copy-IfExists "$env:APPDATA\OpenVPN Connect" "openvpn-connect-appdata"
Copy-IfExists "$env:LOCALAPPDATA\OpenVPN Connect" "openvpn-connect-local"

# Optional VPN files (if present)
Copy-IfExists "$env:USERPROFILE\Downloads\update1.ovpn" "vpn-files\update1.ovpn"

# Optional: ssh only if non-trivial
$ssh = "$env:USERPROFILE\.ssh"
if (Test-Path $ssh) {
    $keys = Get-ChildItem $ssh -File -Force | Where-Object { $_.Name -notmatch '^known_hosts' }
    if ($keys) { Copy-IfExists $ssh "ssh" } else { Write-Host "SKIP: .ssh (only known_hosts)" }
}

# Reports + secrets scan
$archDir = Join-Path $env:USERPROFILE "Documents\Vault\arch-migration"
Copy-IfExists (Join-Path $archDir "arch-preinstall-report.txt") "reports\arch-preinstall-report.txt"
Copy-IfExists (Join-Path $archDir "secrets-scan.txt") "reports\secrets-scan.txt"
Copy-IfExists (Join-Path $archDir "winget-packages.json") "reports\winget-packages.json"

@{
    ComputerName = $env:COMPUTERNAME
    Date         = (Get-Date).ToString('o')
    User         = $env:USERNAME
    Destination  = $root
    Note         = "Obsidian Vault on GitHub (obsidian remote). Pictures=iCloud. No .env in local scan."
} | ConvertTo-Json | Set-Content (Join-Path $root "manifest.json")

Write-Host ""
Write-Host "Done: $root"
Write-Host "Verify from MAIN PC. iCloud Photos not copied."
