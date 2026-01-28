# Automatic issue resolution

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
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
