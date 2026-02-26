# Set GitHub Actions repo secrets from .env.local.
# Run from repo root. Requires: gh CLI authenticated (or GH_TOKEN), .env.local with values.
# Preview: -DryRun shows what would be set without values. Apply: run without -DryRun.
# Store-affecting: Enables shopify-sync workflow; requires approval per workflow rules.

param(
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) {
    (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
} else {
    (Get-Location).Path
}
Set-Location $repoPath

$envPath = Join-Path $repoPath ".env.local"
if (-not (Test-Path $envPath)) {
    Write-Host "Error: .env.local not found. Populate it first (see docs/status/CREDENTIAL_SETUP_STEPS.md)." -ForegroundColor Red
    exit 1
}

$secretsToSet = @(
    @{ Name = "SHOPIFY_STORE_DOMAIN"; Key = "SHOPIFY_STORE_DOMAIN" },
    @{ Name = "SHOPIFY_ACCESS_TOKEN"; Key = "SHOPIFY_ACCESS_TOKEN" },
    @{ Name = "SHOPIFY_THEME_ID"; Key = "SHOPIFY_THEME_ID" }
)

$values = @{}
foreach ($line in (Get-Content $envPath)) {
    $line = $line.Trim()
    if ($line -and -not $line.StartsWith("#") -and $line -match "^([^=]+)=(.*)$") {
        $k = $matches[1].Trim()
        $v = $matches[2].Trim().Trim("'`"")
        if ($v -and $v -notmatch "your_.*_here") {
            $values[$k] = $v
        }
    }
}

$gh = Get-Command gh -ErrorAction SilentlyContinue
if (-not $gh) {
    $ghPath = "C:\Program Files\GitHub CLI\gh.exe"
    if (-not (Test-Path $ghPath)) {
        Write-Host "Error: GitHub CLI (gh) not found. Install from https://cli.github.com/" -ForegroundColor Red
        exit 1
    }
    $gh = $ghPath
}

if ($DryRun) {
    Write-Host "=== Dry run: GitHub Actions secrets to set ===" -ForegroundColor Cyan
    foreach ($s in $secretsToSet) {
        $v = $values[$s.Key]
        $status = if ($v) { "would set (value present)" } else { "skip (missing in .env.local)" }
        Write-Host "  $($s.Name): $status" -ForegroundColor $(if ($v) { "Green" } else { "Gray" })
    }
    Write-Host ""
    Write-Host "To apply: run without -DryRun (enables shopify-sync workflow)." -ForegroundColor Yellow
    exit 0
}

$setCount = 0
foreach ($s in $secretsToSet) {
    $v = $values[$s.Key]
    if (-not $v) { continue }
    try {
        $v | & $gh secret set $s.Name --repo toodeceptive/against-the-odds
        $setCount++
        Write-Host "[OK] Set $($s.Name)" -ForegroundColor Green
    } catch {
        Write-Host "[FAIL] $($s.Name): $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Set $setCount secret(s). Verify with: .\scripts\github\verify-secrets.ps1" -ForegroundColor Cyan
