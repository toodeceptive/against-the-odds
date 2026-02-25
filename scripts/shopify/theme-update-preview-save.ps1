# Theme update -> preview -> save (permanent automation).
# 1) Update theme (merge brand, copy images) without pushing.
# 2) You run theme-dev in another terminal; when preview is ready, script captures a screenshot (optional).
# 3) Optionally push to store when you confirm.
# See docs/AUTOMATION_IMPLEMENTATION_GUIDE.md.

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$ThemePath = $null,
    [bool]$CapturePreview = $true,
    [switch]$SkipPush = $false
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) {
    (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
} else {
    (Get-Location).Path
}
Set-Location $repoPath

$themeUpdateScript = Join-Path $PSScriptRoot "theme-update-store.ps1"
$updateThemeScript = Join-Path $PSScriptRoot "update-theme.ps1"
$captureScript = Join-Path $PSScriptRoot "capture-preview-screenshot.mjs"

Write-Host "=== Theme update -> preview -> save ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Update theme (no push)
Write-Host "[1/3] Updating theme (merge brand, copy images; no push)..." -ForegroundColor Yellow
& $themeUpdateScript -Store $Store -ThemePath $ThemePath -SkipPush
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host ""

# Step 2: Preview + optional capture
Write-Host "[2/3] Preview" -ForegroundColor Yellow
Write-Host "  In another terminal run: .\scripts\shopify\theme-dev.ps1" -ForegroundColor Gray
Write-Host "  When the preview is open at http://127.0.0.1:9292, press Enter here to capture a screenshot (or press Enter to skip)." -ForegroundColor Gray
$null = Read-Host

if ($CapturePreview) {
    $env:ATO_REPO_ROOT = $repoPath
    & node $captureScript "http://127.0.0.1:9292"
    $env:ATO_REPO_ROOT = $null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Preview screenshot saved to docs/screenshots/." -ForegroundColor Green
    }
}
Write-Host ""

# Step 3: Save (push) when confirmed
Write-Host "[3/3] Save to store" -ForegroundColor Yellow
if ($SkipPush) {
    Write-Host "  Skipping push (SkipPush). To push later run: .\scripts\shopify\update-theme.ps1" -ForegroundColor Gray
    exit 0
}

$confirm = Read-Host "Push theme to store now? (y/n)"
if ($confirm -eq 'y' -or $confirm -eq 'Y') {
    & $updateThemeScript -Store $Store -ThemePath $ThemePath
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Theme pushed to store." -ForegroundColor Green
    }
    exit $LASTEXITCODE
} else {
    Write-Host "Push skipped. Run .\scripts\shopify\update-theme.ps1 when ready." -ForegroundColor Gray
    exit 0
}
