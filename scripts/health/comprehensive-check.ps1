# Comprehensive health check for all systems

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Comprehensive Health Check ===" -ForegroundColor Cyan
Write-Host ""

# Run all health checks
& "scripts\sync\health-check.ps1"
Write-Host ""

& "scripts\monitoring\performance-check.ps1"
Write-Host ""

& "scripts\setup\verify-credentials.ps1" -Quiet
Write-Host ""

Write-Host "=== Health Check Complete ===" -ForegroundColor Cyan
Write-Host "Reports saved to docs/status/" -ForegroundColor Cyan
