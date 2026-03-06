# Run the canonical quality gate, with optional informational audit output.

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Quality Checks ===" -ForegroundColor Cyan
Write-Host ""

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Node.js/npm not found" -ForegroundColor Red
    exit 1
}

Write-Host "Running canonical quality gate..." -ForegroundColor Yellow
npm run quality
if ($LASTEXITCODE -ne 0) {
    Write-Host "[FAIL] Canonical quality gate failed" -ForegroundColor Red
    exit $LASTEXITCODE
}
Write-Host "[OK] Quality gate passed" -ForegroundColor Green
Write-Host ""

if (Test-Path "package.json") {
    Write-Host "Running informational npm audit..." -ForegroundColor Yellow
    npm audit --audit-level=high
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[WARN] npm audit reported vulnerabilities (informational; does not fail check-all.ps1)" -ForegroundColor Yellow
        Write-Host "Run 'npm audit fix' only after reviewing the impact on lockfile and dependencies." -ForegroundColor White
    } else {
        Write-Host "[OK] npm audit passed" -ForegroundColor Green
    }
    Write-Host ""
}

Write-Host "[OK] check-all.ps1 complete" -ForegroundColor Green
exit 0
