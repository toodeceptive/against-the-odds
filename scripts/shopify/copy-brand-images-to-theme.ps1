# Copy brand images from repo assets/brand into the theme assets folder.
# Run before theme push so the store has all uploaded brand PNGs.
# Repo root from script location.

param(
    [string]$ThemePath = $null
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
$brandAssetsPath = Join-Path (Join-Path $repoPath "assets") "brand"

Set-Location $repoPath

Write-Host "=== Copy brand images to theme ===" -ForegroundColor Cyan
Write-Host "Source: $brandAssetsPath" -ForegroundColor Gray
Write-Host "Target: $ThemePath\assets" -ForegroundColor Gray
Write-Host ""

if (-not (Test-Path $brandAssetsPath)) {
    Write-Host "Warning: Brand assets folder not found. Skipping." -ForegroundColor Yellow
    exit 0
}

$themeAssets = Join-Path $ThemePath "assets"
New-Item -ItemType Directory -Force -Path $themeAssets | Out-Null

$count = 0
Get-ChildItem -Path $brandAssetsPath -Filter "*.png" -File | ForEach-Object {
    $base = $_.BaseName
    $ext = $_.Extension
    # Sanitize: replace spaces and problematic chars for theme asset names
    $safe = $base -replace '\s+', '-' -replace '[^a-zA-Z0-9\-_]', ''
    if ([string]::IsNullOrWhiteSpace($safe)) { $safe = "ao-brand-$count" }
    $destName = "$safe$ext"
    $destPath = Join-Path $themeAssets $destName
    Copy-Item -Path $_.FullName -Destination $destPath -Force
    Write-Host "  [OK] $($_.Name) -> $destName" -ForegroundColor Green
    $count++
}

if ($count -eq 0) {
    Write-Host "No PNG files found in assets/brand." -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "[OK] Copied $count brand image(s) to theme assets." -ForegroundColor Green
}
