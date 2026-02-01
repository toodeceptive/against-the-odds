# Pull the current Shopify theme into the repo
# Uses "npx shopify theme pull" so the theme CLI is used (not a different global "shopify" e.g. Hydrogen).
# Repo root resolved from script location for cross-platform/CI.

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$ThemePath = $null,
    [string]$Theme = "live"
)

$ErrorActionPreference = "Stop"

$repoPath = if ($PSScriptRoot) {
    $parent = Join-Path $PSScriptRoot ".."
    (Resolve-Path (Join-Path $parent "..")).Path
} else {
    (Get-Location).Path
}
if (-not $ThemePath) {
    $ThemePath = Join-Path (Join-Path (Join-Path (Join-Path $repoPath "src") "shopify") "themes") "aodrop-theme"
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

Write-Host "=== Shopify Theme Pull ===" -ForegroundColor Cyan
Write-Host ""

# Ensure theme CLI is available (install globally if missing; we still invoke via npx for consistency)
. "$PSScriptRoot\Ensure-ShopifyCli.ps1"

if ([string]::IsNullOrWhiteSpace($Store)) {
    Write-Host "Error: SHOPIFY_STORE_DOMAIN not set (expected aodrop.com)." -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Force -Path $ThemePath | Out-Null

# Use permanent store domain (myshopify.com) for theme CLI — Shopify often requires it for auth.
$storeForCli = $Store
if ($Store -eq "aodrop.com" -or $Store -match "^aodrop\.com$") {
    $storeForCli = "aodrop.com.myshopify.com"
}

# Theme CLI accepts --password (Admin API or Theme Access token) for non-interactive pull
$themeToken = $env:SHOPIFY_CLI_THEME_TOKEN
if ([string]::IsNullOrWhiteSpace($themeToken)) { $themeToken = $env:SHOPIFY_ACCESS_TOKEN }

Write-Host "Pulling theme '$Theme' from $storeForCli into $ThemePath" -ForegroundColor Yellow
Write-Host "Using: npx shopify theme pull (theme CLI)" -ForegroundColor Gray
if ($themeToken) {
    Write-Host "Using token from SHOPIFY_CLI_THEME_TOKEN / SHOPIFY_ACCESS_TOKEN (non-interactive)." -ForegroundColor Gray
} else {
    Write-Host "If you see a verification code: press a key to open the browser, confirm the code, then return here and wait 30–60s." -ForegroundColor Gray
}
Write-Host ""

# Disable interactive prompts (e.g. "Do you want to proceed?" when not in theme directory)
[Environment]::SetEnvironmentVariable("SHOPIFY_FLAG_FORCE", "1", "Process")

# Use npx explicitly so we always use @shopify/cli theme pull (avoids wrong global "shopify" e.g. Hydrogen).
# Pass --path and path as separate args so Windows paths (e.g. C:\...) are not mangled.
# Run without capturing so output streams in real time (avoids "frozen" appearance).
$pullArgs = @("shopify", "theme", "pull", "--store=$storeForCli", "--theme=$Theme", "--path", $ThemePath)
if ($themeToken) {
    $pullArgs += "--password"
    $pullArgs += $themeToken
}
& npx $pullArgs

if ($LASTEXITCODE -ne 0) {
    Write-Host "[FAIL] Theme pull failed" -ForegroundColor Red
    Write-Host "If you see 'not authorized': run .\scripts\shopify\theme-auth-then-pull.ps1 or .\scripts\shopify\theme-auth-via-browser.ps1" -ForegroundColor Yellow
    Write-Host "If you see an SSL/network error: see docs/TROUBLESHOOTING.md (Theme pull: SSL/TLS handshake failure)." -ForegroundColor Gray
    exit 1
}

Write-Host "[OK] Theme pull complete" -ForegroundColor Green
