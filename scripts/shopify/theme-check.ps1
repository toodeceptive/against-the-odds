# Run shopify theme check; exit code for CI/agents.
# Run from repo root: .\scripts\shopify\theme-check.ps1

param()

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

$themePath = "src/shopify/themes/aodrop-theme"
if (-not (Test-Path $themePath)) {
    Write-Host "Theme path not found: $themePath" -ForegroundColor Red
    exit 1
}

Write-Host "Running Theme Check on $themePath..." -ForegroundColor Cyan
& shopify theme check --path=$themePath
exit $LASTEXITCODE
