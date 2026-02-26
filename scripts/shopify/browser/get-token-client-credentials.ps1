# Get Admin API access token via client credentials grant and save to .env.local.
# Requires SHOPIFY_API_KEY and SHOPIFY_API_SECRET (and optionally SHOPIFY_STORE_DOMAIN) in .env.local.

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

$envPath = Join-Path $repoPath ".env.local"
if (-not (Test-Path $envPath)) { Write-Host "Error: .env.local not found." -ForegroundColor Red; exit 1 }

$content = Get-Content $envPath
$apiKey = $null
$apiSecret = $null
$storeDomain = "aodrop.com"
$myshopifyDomain = $null
foreach ($line in $content) {
    if ($line -match '^SHOPIFY_API_KEY=(.+)$') { $apiKey = $matches[1].Trim() }
    if ($line -match '^SHOPIFY_API_SECRET=(.+)$') { $apiSecret = $matches[1].Trim() }
    if ($line -match '^SHOPIFY_STORE_DOMAIN=(.+)$') { $storeDomain = $matches[1].Trim() }
    if ($line -match '^SHOPIFY_MYSHOPIFY_DOMAIN=(.+)$') { $myshopifyDomain = $matches[1].Trim() }
}

if ([string]::IsNullOrWhiteSpace($apiKey) -or $apiKey -match 'your_.*_here') {
    Write-Host "Error: SHOPIFY_API_KEY not set in .env.local." -ForegroundColor Red
    exit 1
}
if ([string]::IsNullOrWhiteSpace($apiSecret) -or $apiSecret -match 'your_.*_here') {
    Write-Host "Error: SHOPIFY_API_SECRET not set in .env.local." -ForegroundColor Red
    exit 1
}

# Use the myshopify host for OAuth token exchange.
$hostOnly = ($storeDomain -replace '^https?://', '' -replace '/.*$', '').ToLowerInvariant()
$oauthHost = $null

if ($hostOnly -match '\.myshopify\.com$') {
    $oauthHost = $hostOnly
} elseif (-not [string]::IsNullOrWhiteSpace($myshopifyDomain)) {
    $oauthHost = ($myshopifyDomain -replace '^https?://', '' -replace '/.*$', '').ToLowerInvariant()
} elseif ($hostOnly -eq "aodrop.com") {
    $oauthHost = "aodrop.com.myshopify.com"
} else {
    Write-Host "Error: Could not determine myshopify domain for OAuth." -ForegroundColor Red
    Write-Host "Set SHOPIFY_MYSHOPIFY_DOMAIN in .env.local (example: your-store.myshopify.com)." -ForegroundColor Yellow
    exit 1
}

$uri = "https://$oauthHost/admin/oauth/access_token"

$body = @{
    grant_type    = "client_credentials"
    client_id     = $apiKey
    client_secret = $apiSecret
}

try {
    $response = Invoke-RestMethod -Uri $uri -Method Post -Body $body -ContentType "application/x-www-form-urlencoded"
    $token = $response.access_token
    if ([string]::IsNullOrWhiteSpace($token)) {
        Write-Host "Error: No access_token in response." -ForegroundColor Red
        exit 1
    }

    $content = Get-Content $envPath
    $updated = $false
    $newContent = @()
    foreach ($line in $content) {
        if ($line -match '^SHOPIFY_ACCESS_TOKEN=(.*)$') {
            $newContent += "SHOPIFY_ACCESS_TOKEN=$token"
            $updated = $true
        } else {
            $newContent += $line
        }
    }
    if (-not $updated) { $newContent += "SHOPIFY_ACCESS_TOKEN=$token" }
    $newContent | Out-File -FilePath $envPath -Encoding UTF8

    Write-Host "[OK] Access token obtained and saved to .env.local." -ForegroundColor Green
    Write-Host "Verify with: .\scripts\run-runbook.ps1" -ForegroundColor Cyan
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.BaseStream.Position = 0
        Write-Host $reader.ReadToEnd() -ForegroundColor Yellow
    }
    exit 1
}
