# Fix theme auth using browser: launch Chrome at Shopify Admin, extract token, then pull theme.
# Use when device-code auth fails ("not authorized") or you prefer token-based auth.
# Run from repo root. Requires: Chrome, Node/Playwright (for get-access-token), .env.local with SHOPIFY_STORE_DOMAIN.

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [switch]$SkipPull = $false,
    [switch]$SkipChromeLaunch = $false
)

$ErrorActionPreference = "Stop"

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
            [Environment]::SetEnvironmentVariable($matches[1].Trim(), $matches[2].Trim(), "Process")
        }
    }
}
if ([string]::IsNullOrWhiteSpace($Store)) { $Store = $env:SHOPIFY_STORE_DOMAIN }
if ([string]::IsNullOrWhiteSpace($Store)) {
    Write-Host "Error: SHOPIFY_STORE_DOMAIN not set. Set in .env.local or pass -Store." -ForegroundColor Red
    exit 1
}

$adminHost = $Store
if ($Store -match "\.myshopify\.com$") { $adminHost = $Store -replace "\.myshopify\.com$", "" }

Write-Host "=== Theme auth via browser (Chrome + token) ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Launch Chrome at Shopify Admin (unless user already has Chrome open with Shopify)
if (-not $SkipChromeLaunch) {
    $adminUrl = "https://$adminHost/admin"
    Write-Host "[1/3] Launching Chrome at $adminUrl ..." -ForegroundColor Yellow
    & "$PSScriptRoot\browser\launch-chrome-for-agent.ps1" -Url $adminUrl
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Write-Host "Log in to Shopify in the opened window if needed. When ready, press Enter to continue." -ForegroundColor Cyan
    Read-Host
} else {
    Write-Host "[1/3] Skipping Chrome launch (use existing Chrome with Shopify Admin open)." -ForegroundColor Gray
}

# Step 2: Extract token from browser and save to .env.local (SHOPIFY_ACCESS_TOKEN + SHOPIFY_CLI_THEME_TOKEN)
Write-Host ""
Write-Host "[2/3] Extracting access token from browser (Apps > Development)..." -ForegroundColor Yellow
& "$PSScriptRoot\browser\get-access-token.ps1" -StoreDomain $adminHost -SaveToEnv
if ($LASTEXITCODE -ne 0) {
    Write-Host "[FAIL] Could not extract token. Ensure you're logged in to https://$adminHost/admin and have a Development app with API credentials visible." -ForegroundColor Red
    Write-Host "Alternatively: run theme-auth-then-pull.ps1 for device-code login." -ForegroundColor Yellow
    exit 1
}

# Reload .env.local so theme-pull sees SHOPIFY_CLI_THEME_TOKEN
if (Test-Path ".env.local") {
    Get-Content ".env.local" | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#") -and $line -match "^([^=]+)=(.*)$") {
            [Environment]::SetEnvironmentVariable($matches[1].Trim(), $matches[2].Trim(), "Process")
        }
    }
}

if ($SkipPull) {
    Write-Host "[OK] Token saved. Run .\scripts\shopify\theme-pull.ps1 when ready." -ForegroundColor Green
    exit 0
}

# Step 3: Pull theme (non-interactive with token)
Write-Host ""
Write-Host "[3/3] Pulling theme (using token)..." -ForegroundColor Yellow
& "$PSScriptRoot\theme-pull.ps1" -Store $Store
exit $LASTEXITCODE
