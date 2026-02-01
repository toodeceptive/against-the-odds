# Merge AO brand customization into aodrop-theme (run after theme-pull).
# Copies brand assets/snippets and patches layout/theme.liquid when present.
# Repo root resolved from script location.

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
$brandPkg = Join-Path (Join-Path (Join-Path (Join-Path $repoPath "src") "shopify") "themes") "ao-brand-customization"

Set-Location $repoPath

Write-Host "=== Merge AO brand into theme ===" -ForegroundColor Cyan
Write-Host "Theme: $ThemePath" -ForegroundColor Gray
Write-Host ""

if (-not (Test-Path $brandPkg)) {
    Write-Host "Error: Brand package not found at $brandPkg" -ForegroundColor Red
    exit 1
}

# Copy assets
$themeAssets = Join-Path $ThemePath "assets"
$themeSnippets = Join-Path $ThemePath "snippets"
New-Item -ItemType Directory -Force -Path $themeAssets | Out-Null
New-Item -ItemType Directory -Force -Path $themeSnippets | Out-Null

$cssSrc = Join-Path $brandPkg "assets\ao-brand.css"
$snippetSrc = Join-Path $brandPkg "snippets\ao-hero-brand.liquid"
if (Test-Path $cssSrc) {
    Copy-Item -Path $cssSrc -Destination (Join-Path $themeAssets "ao-brand.css") -Force
    Write-Host "[OK] Copied ao-brand.css to theme assets" -ForegroundColor Green
}
if (Test-Path $snippetSrc) {
    Copy-Item -Path $snippetSrc -Destination (Join-Path $themeSnippets "ao-hero-brand.liquid") -Force
    Write-Host "[OK] Copied ao-hero-brand.liquid to theme snippets" -ForegroundColor Green
}

# Patch layout/theme.liquid if it exists
$layoutFile = Join-Path $ThemePath "layout\theme.liquid"
if (-not (Test-Path $layoutFile)) {
    Write-Host "[SKIP] No layout/theme.liquid; add stylesheet and body class manually (see LAYOUT_STEPS.md)" -ForegroundColor Yellow
    exit 0
}

$content = Get-Content -Path $layoutFile -Raw -Encoding UTF8
$modified = $false
$stylesheetTag = "{{ 'ao-brand.css' | asset_url | stylesheet_tag }}"

# Add ao-brand.css after base.css stylesheet if not already present
if ($content -notmatch "ao-brand\.css") {
    if ($content -match "(\{\{\s*'base\.css'\s*\|\s*asset_url\s*\|\s*stylesheet_tag\s*\}\})") {
        $content = $content -replace "(\{\{\s*'base\.css'\s*\|\s*asset_url\s*\|\s*stylesheet_tag\s*\}\})", "`$1`r`n  $stylesheetTag"
        $modified = $true
    } else {
        $headClose = [regex]::Escape("</head>")
        if ($content -match $headClose) {
            $content = $content -replace "($headClose)", "  $stylesheetTag`r`n  `$1"
            $modified = $true
        }
    }
}

# Add ao-brand-theme to body class if not already present (Dawn may use <body> or <body class="...">)
if ($content -notmatch "ao-brand-theme") {
    if ($content -match '<body\s+class="([^"]*)"') {
        $content = $content -replace '<body\s+class="([^"]*)"', '<body class="$1 ao-brand-theme"'
        $modified = $true
    } elseif ($content -match '<body\s*>') {
        $content = $content -replace '<body\s*>', '<body class="ao-brand-theme">'
        $modified = $true
    }
}

if ($modified) {
    Set-Content -Path $layoutFile -Value $content -Encoding UTF8 -NoNewline
    Write-Host "[OK] Patched layout/theme.liquid (stylesheet + body class)" -ForegroundColor Green
} else {
    Write-Host "[OK] layout/theme.liquid already has AO brand (no patch needed)" -ForegroundColor Green
}

Write-Host ""
Write-Host "Merge complete. Run theme-dev.ps1 to preview." -ForegroundColor Cyan
