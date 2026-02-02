# Pull theme via Shopify REST Admin API (PowerShell/.NET TLS — use when Node CLI fails with SSL).
# Requires SHOPIFY_ACCESS_TOKEN or SHOPIFY_CLI_THEME_TOKEN and themes scope.
# API: GET themes.json, GET themes/{id}/assets.json, GET assets.json?asset[key]=...

param(
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$ThemePath = $null,
    [string]$Theme = "live"
)

$ErrorActionPreference = "Stop"

# Force TLS 1.2+ for Shopify (some Windows/.NET defaults use older TLS)
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
} catch {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}

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

$Store = if ([string]::IsNullOrWhiteSpace($Store)) { $env:SHOPIFY_STORE_DOMAIN } else { $Store }
$token = $env:SHOPIFY_CLI_THEME_TOKEN
if ([string]::IsNullOrWhiteSpace($token)) { $token = $env:SHOPIFY_ACCESS_TOKEN }

if ([string]::IsNullOrWhiteSpace($Store) -or [string]::IsNullOrWhiteSpace($token)) {
    Write-Host "Error: SHOPIFY_STORE_DOMAIN and SHOPIFY_ACCESS_TOKEN (or SHOPIFY_CLI_THEME_TOKEN) required for REST pull." -ForegroundColor Red
    exit 1
}

$storeHost = $Store
if ($Store -eq "aodrop.com" -or $Store -match "^aodrop\.com$") {
    $storeHost = "aodrop.com.myshopify.com"
}
$baseUrl = "https://$storeHost/admin/api/2026-01"
$headers = @{
    "X-Shopify-Access-Token" = $token
    "Content-Type"           = "application/json"
}

Write-Host "=== Shopify Theme Pull (REST API) ===" -ForegroundColor Cyan
Write-Host "Store: $storeHost -> $ThemePath" -ForegroundColor Gray
Write-Host ""

# 1) List themes, find main (live)
try {
    $themesResp = Invoke-RestMethod -Uri "$baseUrl/themes.json" -Headers $headers -Method Get
} catch {
    Write-Host "Error listing themes: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "Token may be invalid or expired. Re-auth: .\scripts\shopify\theme-auth-then-pull.ps1 or theme-auth-via-browser.ps1" -ForegroundColor Yellow
    }
    exit 1
}

$roleMatch = if ($Theme -eq "live") { "main" } else { $Theme }
$themeObj = $themesResp.themes | Where-Object { $_.role -eq $roleMatch } | Select-Object -First 1
if (-not $themeObj) {
    Write-Host "Error: No theme with role '$roleMatch' found." -ForegroundColor Red
    exit 1
}
$themeId = $themeObj.id
Write-Host "Theme ID: $themeId ($($themeObj.name))" -ForegroundColor Gray

# 2) List all assets (metadata only); paginate via Link header
$allKeys = @()
$uri = "$baseUrl/themes/$themeId/assets.json?limit=250"
do {
    $resp = Invoke-WebRequest -Uri $uri -Headers $headers -Method Get -UseBasicParsing
    $assetsResp = $resp.Content | ConvertFrom-Json
    foreach ($a in $assetsResp.assets) { $allKeys += $a.key }
    $uri = $null
    $linkHeader = $resp.Headers["Link"]
    if ($linkHeader -match '<([^>]+)>;\s*rel="next"') {
        $uri = $matches[1]
    }
} while ($uri)

Write-Host "Assets to download: $($allKeys.Count)" -ForegroundColor Gray
New-Item -ItemType Directory -Force -Path $ThemePath | Out-Null

# 3) Fetch each asset and write to disk
$written = 0
$failed = 0
foreach ($key in $allKeys) {
    $uri = "$baseUrl/themes/$themeId/assets.json?asset[key]=$([uri]::EscapeDataString($key))"
    try {
        $assetResp = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
        $asset = $assetResp.asset
        $fullPath = Join-Path $ThemePath $key
        $dir = Split-Path $fullPath -Parent
        if (-not [string]::IsNullOrEmpty($dir)) {
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
        }
        if ($asset.PSObject.Properties["value"] -and $null -ne $asset.value) {
            [System.IO.File]::WriteAllText($fullPath, $asset.value, [System.Text.UTF8Encoding]::new($false))
        } elseif ($asset.PSObject.Properties["attachment"] -and $null -ne $asset.attachment) {
            $bytes = [Convert]::FromBase64String($asset.attachment.Trim())
            [System.IO.File]::WriteAllBytes($fullPath, $bytes)
        } else {
            Write-Host "  Skip (no value/attachment): $key" -ForegroundColor DarkGray
            continue
        }
        $written++
        if ($written % 20 -eq 0) { Write-Host "  $written / $($allKeys.Count)" -ForegroundColor DarkGray }
    } catch {
        $failed++
        Write-Host "  FAIL: $key - $($_.Exception.Message)" -ForegroundColor Red
    }
    Start-Sleep -Milliseconds 120
}

Write-Host ""
if ($failed -gt 0) {
    Write-Host "[OK] Theme pull (REST) complete with $failed error(s): $written written" -ForegroundColor Yellow
    exit 1
}
Write-Host "[OK] Theme pull (REST) complete: $written files" -ForegroundColor Green
exit 0
