# Scan for .env and token-like files (local only, not iCloud placeholders).
$Report = Join-Path $PSScriptRoot 'secrets-scan.txt'
$exclude = @('node_modules', '.git', 'AppData\Local\Packages', 'iCloud Photos')

"=== $(Get-Date) ===" | Out-File $Report -Encoding utf8
$roots = @(
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\Downloads"
)

"--- .env / env.local files ---" | Out-File $Report -Append -Encoding utf8
foreach ($root in $roots) {
    if (-not (Test-Path $root)) { continue }
    Get-ChildItem $root -Recurse -File -Force -ErrorAction SilentlyContinue |
        Where-Object {
            $p = $_.FullName
            ($exclude | ForEach-Object { $p -notlike "*$_*" }) -notcontains $false
        } |
        Where-Object { $_.Name -match '^\.env(\.|$)' -or $_.Name -in '.env.local', '.env.development' } |
        ForEach-Object { $_.FullName } |
        Out-File $Report -Append -Encoding utf8
}

"--- .ssh ---" | Out-File $Report -Append -Encoding utf8
if (Test-Path "$env:USERPROFILE\.ssh") {
    Get-ChildItem "$env:USERPROFILE\.ssh" -Force | ForEach-Object { "$($_.Name) $($_.Length) bytes" } |
        Out-File $Report -Append -Encoding utf8
} else {
    'no .ssh' | Out-File $Report -Append -Encoding utf8
}

"--- VPN (.ovpn) ---" | Out-File $Report -Append -Encoding utf8
foreach ($root in @($env:USERPROFILE, "$env:USERPROFILE\Documents", "$env:USERPROFILE\Downloads")) {
    if (Test-Path $root) {
        Get-ChildItem $root -Recurse -Filter '*.ovpn' -File -ErrorAction SilentlyContinue -Depth 6 |
            Select-Object -ExpandProperty FullName |
            Out-File $Report -Append -Encoding utf8
    }
}

"--- Obsidian vault ---" | Out-File $Report -Append -Encoding utf8
$vault = "$env:USERPROFILE\Documents\Vault"
if (Test-Path $vault) {
    $sum = (Get-ChildItem $vault -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
    "$vault : $([math]::Round($sum / 1MB, 2)) MB" | Out-File $Report -Append -Encoding utf8
}

"--- Pictures (iCloud?) ---" | Out-File $Report -Append -Encoding utf8
$pics = "$env:USERPROFILE\Pictures"
if (Test-Path $pics) {
    $item = Get-Item $pics -Force
    "Attributes: $($item.Attributes)" | Out-File $Report -Append -Encoding utf8
    Get-ChildItem $pics -Force -ErrorAction SilentlyContinue | ForEach-Object { $_.Name } |
        Out-File $Report -Append -Encoding utf8
}

Write-Host "Scan: $Report"
Get-Content $Report
