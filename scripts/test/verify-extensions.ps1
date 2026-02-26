# Verify extension-backed test suites (Vitest, Playwright, Theme Check).
# Run from repo root: .\scripts\test\verify-extensions.ps1
# Exit 0 only if unit tests pass; E2E and Theme Check are best-effort.

param()

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

$failed = 0

Write-Host "=== Extension Verification ===" -ForegroundColor Cyan
Write-Host ""

# 1. Unit tests (Vitest) - required
Write-Host "[1/3] Unit tests (Vitest)..." -ForegroundColor Yellow
npm run test:unit 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "  FAIL" -ForegroundColor Red
    $failed++
} else {
    Write-Host "  OK" -ForegroundColor Green
}
Write-Host ""

# 2. E2E tests (Playwright) - best-effort
Write-Host "[2/3] E2E tests (Playwright) - best-effort..." -ForegroundColor Yellow
try { npm run test:e2e 2>&1 | Out-Null } catch { $null }
if ($LASTEXITCODE -ne 0) {
    Write-Host "  FAIL (may need Python, webServer, or npx playwright install)" -ForegroundColor Yellow
} else {
    Write-Host "  OK" -ForegroundColor Green
}
Write-Host ""

# 3. Theme Check - best-effort
Write-Host "[3/3] Theme Check - best-effort..." -ForegroundColor Yellow
$themeCheckScript = Join-Path $repoPath "scripts/shopify/theme-check.ps1"
if (Test-Path $themeCheckScript) {
    try { & $themeCheckScript 2>&1 | Out-Null } catch { $null }
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  FAIL (may need Shopify CLI)" -ForegroundColor Yellow
    } else {
        Write-Host "  OK" -ForegroundColor Green
    }
} else {
    Write-Host "  (theme-check.ps1 not found, skip)" -ForegroundColor Gray
}
Write-Host ""

if ($failed -gt 0) {
    Write-Host "Verification failed: unit tests did not pass." -ForegroundColor Red
    exit 1
}
Write-Host "Verification passed." -ForegroundColor Green
exit 0
