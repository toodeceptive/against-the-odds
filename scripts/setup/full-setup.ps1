# Full setup orchestrator: ensure .env.local, guide credentials, verify.
# Run from repo root: .\scripts\setup\full-setup.ps1

param(
    [switch]$SkipRunbook = $false
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Full setup ===" -ForegroundColor Cyan
Write-Host ""

& (Join-Path $repoPath "scripts\setup\auto-configure-env.ps1") -Interactive $true -SkipValidation $false

if (-not $SkipRunbook) {
    Write-Host ""
    $run = Read-Host "Run runbook now? (y/n)"
    if ($run -eq "y") {
        & (Join-Path $repoPath "scripts\run-runbook.ps1")
    }
} else {
    Write-Host ""
    Write-Host "Run .\scripts\run-runbook.ps1 to verify." -ForegroundColor Cyan
}
