# Run all tests (unit, integration, E2E)

param(
    [switch]$Unit = $false,
    [switch]$Integration = $false,
    [switch]$E2E = $false,
    [switch]$Coverage = $false
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Test Runner ===" -ForegroundColor Cyan
Write-Host ""

# Check if Node.js is installed
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Node.js/npm not found" -ForegroundColor Red
    Write-Host "Install Node.js from https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Install dependencies if needed
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    npm install
}

$allPassed = $true

# Run unit tests
if ($Unit -or (-not $Integration -and -not $E2E)) {
    Write-Host "Running unit tests..." -ForegroundColor Yellow
    if ($Coverage) {
        npm run test:coverage
    } else {
        npm run test:unit
    }
    if ($LASTEXITCODE -ne 0) {
        $allPassed = $false
    }
    Write-Host ""
}

# Run integration tests
if ($Integration -or (-not $Unit -and -not $E2E)) {
    Write-Host "Running integration tests..." -ForegroundColor Yellow
    npm run test:integration
    if ($LASTEXITCODE -ne 0) {
        $allPassed = $false
    }
    Write-Host ""
}

# Run E2E tests
if ($E2E -or (-not $Unit -and -not $Integration)) {
    Write-Host "Running E2E tests..." -ForegroundColor Yellow
    npm run test:e2e
    if ($LASTEXITCODE -ne 0) {
        $allPassed = $false
    }
    Write-Host ""
}

if ($allPassed) {
    Write-Host "[OK] All tests passed!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "[FAIL] Some tests failed" -ForegroundColor Red
    exit 1
}
