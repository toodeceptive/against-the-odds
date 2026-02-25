# Automatic issue resolution

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Automatic Issue Resolution ===" -ForegroundColor Cyan
Write-Host ""

# Run auto-fix
& "scripts\sync\auto-fix.ps1"

# Verify fixes
Write-Host ""
Write-Host "Verifying fixes..." -ForegroundColor Yellow
& "scripts\sync\verify-all.ps1" -AutoFix

Write-Host ""
Write-Success "Auto-repair complete!"
