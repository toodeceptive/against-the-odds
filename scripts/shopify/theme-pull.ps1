# Pull the current Shopify theme into the repo
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

. "$PSScriptRoot\Ensure-ShopifyCli.ps1"

if ([string]::IsNullOrWhiteSpace($Store)) {
    Write-Host "Error: SHOPIFY_STORE_DOMAIN not set (expected aodrop.com)." -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Force -Path $ThemePath | Out-Null

Write-Host "Pulling theme '$Theme' from $Store into $ThemePath" -ForegroundColor Yellow
$args = $ShopifyCmd[1..($ShopifyCmd.Length - 1)] + "theme", "pull", "--store=$Store", "--theme=$Theme", "--path=$ThemePath"
& $ShopifyCmd[0] $args

if ($LASTEXITCODE -ne 0) {
    Write-Host "[FAIL] Theme pull failed" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Theme pull complete" -ForegroundColor Green
