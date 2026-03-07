# One-command setup: open Shopify login in browser, then pull theme after you sign in.
# Run from repo root. Best for first-time or "not authorized" — opens browser, you sign in, then pull runs.
# Uses npx shopify so the theme CLI is used.

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [switch]$SkipPull = $false
)

$ErrorActionPreference = "Stop"
. "$PSScriptRoot\ShopifyStoreHelpers.ps1"

$repoPath = if ($PSScriptRoot) {
    $parent = Join-Path $PSScriptRoot ".."
    (Resolve-Path (Join-Path $parent "..")).Path
} else {
    (Get-Location).Path
}
Set-Location $repoPath

if (Test-Path ".env.local") {
    Get-Content ".env.local" | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#") -and $line -match "^([^=]+)=(.*)$") {
            $key = $matches[1].Trim()
            $val = $matches[2].Trim()
            [Environment]::SetEnvironmentVariable($key, $val, "Process")
        }
    }
}
if ([string]::IsNullOrWhiteSpace($Store)) { $Store = $env:SHOPIFY_STORE_DOMAIN }

if ([string]::IsNullOrWhiteSpace($Store)) {
    Write-Host "Error: SHOPIFY_STORE_DOMAIN not set (e.g. aodrop.com). Set in .env.local or pass -Store." -ForegroundColor Red
    exit 1
}

# Use the canonical Shopify admin/CLI host rather than synthesizing one from a custom domain.
$storeForCli = (Resolve-ShopifyStoreInfo -Store $Store).CliHost

Write-Host "=== Shopify theme: auth then pull ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Step 1: Opening Shopify login in browser. Sign in as store owner or staff for $storeForCli (choose it when prompted)." -ForegroundColor Yellow
& npx shopify auth login --store $storeForCli
if ($LASTEXITCODE -ne 0) {
    Write-Host "[FAIL] Auth login failed or was cancelled." -ForegroundColor Red
    exit 1
}

if ($SkipPull) {
    Write-Host "[OK] Logged in. Run .\scripts\shopify\theme-pull.ps1 when ready to pull." -ForegroundColor Green
    exit 0
}

Write-Host ""
Write-Host "Step 2: Pulling theme into repo..." -ForegroundColor Yellow
& "$PSScriptRoot\theme-pull.ps1" -Store $Store
exit $LASTEXITCODE
