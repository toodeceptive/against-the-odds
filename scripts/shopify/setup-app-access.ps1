# One-shot Shopify app access setup from Cursor/desktop.
# Ensures Chrome (CDP), extracts Admin API token, saves to .env.local, runs runbook + verify-pipeline.
# For permanent use: run this script whenever you need to (re)establish Shopify API access.
# See docs/SHOPIFY_APP_SETUP_AUTOMATION.md and docs/status/CREDENTIAL_SETUP_STEPS.md.

param(
    [string]$StoreDomain = $env:SHOPIFY_STORE_DOMAIN,
    [switch]$LaunchChrome = $false,
    [switch]$SkipVerify = $false
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) {
    (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
} else {
    (Get-Location).Path
}
if (-not (Test-Path (Join-Path $repoPath ".git"))) {
    Write-Host "Error: Run from repo root (no .git found)." -ForegroundColor Red
    exit 1
}
Set-Location $repoPath

if ([string]::IsNullOrWhiteSpace($StoreDomain)) { $StoreDomain = "aodrop.com" }

$envPath = Join-Path $repoPath ".env.local"
if (-not (Test-Path $envPath)) {
    if (Test-Path (Join-Path $repoPath ".env.example")) {
        Copy-Item (Join-Path $repoPath ".env.example") $envPath
        Write-Host "Created .env.local from .env.example" -ForegroundColor Green
    }
    $content = Get-Content $envPath -Raw -ErrorAction SilentlyContinue
    if ($content -notmatch 'SHOPIFY_STORE_DOMAIN=') {
        Add-Content -Path $envPath -Value "SHOPIFY_STORE_DOMAIN=$StoreDomain"
    }
}

Write-Host "=== Shopify App Access Setup ===" -ForegroundColor Cyan
Write-Host "Store: $StoreDomain | Launch Chrome: $LaunchChrome" -ForegroundColor Gray
Write-Host ""

# Optional: launch Chrome with remote debugging so automation can connect
if ($LaunchChrome) {
    Write-Host "Launching Chrome with remote debugging (port 9222)..." -ForegroundColor Yellow
    & (Join-Path $repoPath "scripts\shopify\browser\launch-chrome-for-agent.ps1") -Url "https://$StoreDomain/admin"
    Write-Host "Log in to Shopify in the opened window, then go to Apps > Development > [your app] > API credentials and click Reveal." -ForegroundColor Cyan
    Write-Host "Press Enter when ready for token extraction..." -ForegroundColor Cyan
    Read-Host
}

# Extract token (connects to Chrome on port 9222 or launches Chromium)
$tokenScript = Join-Path $repoPath "scripts\shopify\browser\get-access-token.ps1"
& $tokenScript -StoreDomain $StoreDomain -SaveToEnv:$true
$tokenOk = $LASTEXITCODE -eq 0

if (-not $tokenOk) {
    Write-Host ""
    Write-Host "Token extraction did not succeed. Options:" -ForegroundColor Yellow
    Write-Host "  1. Copy the Admin API token (shpat_...) from Shopify Admin > Apps > Development > [app] > API credentials (Reveal), then run:" -ForegroundColor White
    Write-Host "     .\scripts\shopify\browser\save-token-to-env.ps1" -ForegroundColor Cyan
    Write-Host "  2. Re-run this script with -LaunchChrome, log in, open API credentials + Reveal, then run again without -LaunchChrome." -ForegroundColor White
    Write-Host ""
    exit 1
}

if ($SkipVerify) {
    Write-Host "[OK] Token saved. Skipping runbook/verify-pipeline (use -SkipVerify:`$false to run)." -ForegroundColor Green
    exit 0
}

# Run runbook and pipeline verification
Write-Host ""
Write-Host "Running runbook and pipeline verification..." -ForegroundColor Cyan
$runbookScript = Join-Path $repoPath "scripts\run-runbook.ps1"
$pipelineScript = Join-Path $repoPath "scripts\verify-pipeline.ps1"
& $runbookScript
$runbookOk = $LASTEXITCODE -eq 0
& $pipelineScript
$pipelineOk = $LASTEXITCODE -eq 0

Write-Host ""
if ($runbookOk -and $pipelineOk) {
    Write-Host "=== Setup complete ===" -ForegroundColor Green
    Write-Host "Runbook and verify-pipeline passed. Shopify app access is configured." -ForegroundColor Green
    exit 0
} else {
    Write-Host "=== Setup partial ===" -ForegroundColor Yellow
    Write-Host "Token was saved. Runbook: $(if ($runbookOk) { 'OK' } else { 'FAILED' }) | Pipeline: $(if ($pipelineOk) { 'OK' } else { 'FAILED' })" -ForegroundColor Yellow
    exit 1
}
