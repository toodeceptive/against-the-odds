# Update the store theme with AO brand: merge brand assets, copy brand images, then push.
# Run after theme-pull at least once so aodrop-theme has full theme structure.
# Requires SHOPIFY_STORE_DOMAIN (and SHOPIFY_THEME_ID for non-live).

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$ThemePath = $null,
    [string]$ThemeId = $env:SHOPIFY_THEME_ID,
    [switch]$Live = $false,
    [switch]$SkipPush = $false
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

Write-Host "=== Update store theme with AO brand ===" -ForegroundColor Cyan
Write-Host ""

# 1. Merge brand CSS and snippet into theme; patch layout if present
& "$PSScriptRoot\merge-brand-into-theme.ps1" -ThemePath $ThemePath
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# 2. Copy brand images from assets/brand into theme assets
& "$PSScriptRoot\copy-brand-images-to-theme.ps1" -ThemePath $ThemePath
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if ($SkipPush) {
    Write-Host ""
    Write-Host "Skipping push (SkipPush). Run .\scripts\shopify\update-theme.ps1 to deploy." -ForegroundColor Yellow
    exit 0
}

# 3. Push theme to Shopify
& "$PSScriptRoot\update-theme.ps1" -Store $Store -ThemePath $ThemePath -ThemeId $ThemeId -Live:$Live
exit $LASTEXITCODE
