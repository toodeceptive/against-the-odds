# Security vulnerability scanning

param(
    [switch]$Fix = $false
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Security Scan ===" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path "package.json")) {
    Write-Host "No package.json found. Skipping security scan." -ForegroundColor Yellow
    exit 0
}

# Check for npm
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "Error: npm not found. Please install Node.js." -ForegroundColor Red
    exit 1
}

Write-Host "Scanning for security vulnerabilities..." -ForegroundColor Yellow

if ($Fix) {
    Write-Host "  Running audit fix..." -ForegroundColor Cyan
    npm audit fix
} else {
    Write-Host "  Running audit (read-only)..." -ForegroundColor Cyan
    npm audit
}

Write-Host ""
Write-Host "[OK] Security scan complete!" -ForegroundColor Green

if ($Fix) {
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Review fixed vulnerabilities" -ForegroundColor Cyan
    Write-Host "  2. Test the application" -ForegroundColor Cyan
    Write-Host "  3. Commit changes if everything works" -ForegroundColor Cyan
}
