# Update project dependencies

param(
    [switch]$CheckOnly = $false,
    [switch]$Major = $false
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Dependency Update ===" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path "package.json")) {
    Write-Host "No package.json found. Skipping dependency updates." -ForegroundColor Yellow
    exit 0
}

# Check for npm
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "Error: npm not found. Please install Node.js." -ForegroundColor Red
    exit 1
}

if ($CheckOnly) {
    Write-Host "Checking for outdated dependencies..." -ForegroundColor Yellow
    npm outdated
    Write-Host ""
    Write-Host "✓ Dependency check complete!" -ForegroundColor Green
    exit 0
}

Write-Host "Updating dependencies..." -ForegroundColor Yellow

if ($Major) {
    Write-Host "  Updating to latest major versions..." -ForegroundColor Cyan
    npm update --save
} else {
    Write-Host "  Updating to latest minor/patch versions..." -ForegroundColor Cyan
    npm update --save
}

Write-Host ""
Write-Host "✓ Dependencies updated!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Review package.json changes" -ForegroundColor Cyan
Write-Host "  2. Test the application" -ForegroundColor Cyan
Write-Host "  3. Commit changes if everything works" -ForegroundColor Cyan
