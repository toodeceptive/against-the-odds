# Pull live theme, merge AO brand, then start preview (automated flow).
# Run from repo root. For theme-pull you may need to run in an interactive terminal once (shopify auth).
#
# Flow: 1) Pull theme (or skip if already pulled)  2) Merge brand into theme  3) Start theme dev → preview URL

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$ThemePath = $null,
    [switch]$SkipPull = $false,
    [switch]$PreviewOnly = $false
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

Write-Host "=== Theme pull + AO brand merge + preview ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Pull (unless skipped or preview-only)
if (-not $PreviewOnly -and -not $SkipPull) {
    Write-Host "[1/3] Pulling live theme (run in interactive terminal if prompted)..." -ForegroundColor Yellow
    & "$PSScriptRoot\theme-pull.ps1" -Store $Store -ThemePath $ThemePath
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Pull failed or requires interactive login. Run manually: .\scripts\shopify\theme-pull.ps1" -ForegroundColor Yellow
        Write-Host "Then re-run this script with -SkipPull to merge brand and preview." -ForegroundColor Yellow
        exit 1
    }
    Write-Host ""
} elseif ($SkipPull) {
    Write-Host "[1/3] Skipping pull (-SkipPull)" -ForegroundColor Gray
} else {
    Write-Host "[1/3] Preview only (-PreviewOnly)" -ForegroundColor Gray
}

# Step 2: Merge brand
Write-Host "[2/3] Merging AO brand into theme..." -ForegroundColor Yellow
& "$PSScriptRoot\merge-brand-into-theme.ps1" -ThemePath $ThemePath
if ($LASTEXITCODE -ne 0) { exit 1 }
Write-Host ""

# Step 3: Preview
Write-Host "[3/3] Starting theme dev server (preview)..." -ForegroundColor Yellow
Write-Host "Open the URL below in your browser to see the AO brand theme." -ForegroundColor Cyan
Write-Host ""
& "$PSScriptRoot\theme-dev.ps1" -Store $Store -ThemePath $ThemePath
