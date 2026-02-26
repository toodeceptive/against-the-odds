# Get Admin API access token via client credentials grant and save to .env.local.
# Requires SHOPIFY_API_KEY and SHOPIFY_API_SECRET (and optionally SHOPIFY_STORE_DOMAIN) in .env.local.

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

function Get-NormalizedHost {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return $null }
    $normalized = ($Value -replace '^https?://', '' -replace '/.*$', '').Trim().ToLowerInvariant()
    if ([string]::IsNullOrWhiteSpace($normalized)) { return $null }
    return $normalized
}

function Add-HostCandidate {
    param(
        [System.Collections.Generic.List[string]]$List,
        [string]$HostValue
    )
    $normalized = Get-NormalizedHost $HostValue
    if ([string]::IsNullOrWhiteSpace($normalized)) { return }
    if ($normalized -notmatch '^[a-z0-9.-]+$') { return }
    if (-not $List.Contains($normalized)) {
        [void]$List.Add($normalized)
    }
}

function Get-ErrorResponseBody {
    param($ErrorRecord)
    if (-not $ErrorRecord) { return $null }
    if ($ErrorRecord.ErrorDetails -and -not [string]::IsNullOrWhiteSpace($ErrorRecord.ErrorDetails.Message)) {
        return $ErrorRecord.ErrorDetails.Message
    }
    $response = $ErrorRecord.Exception.Response
    if (-not $response) { return $null }
    try {
        if ($response -is [System.Net.Http.HttpResponseMessage]) {
            return $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        }
    } catch {}
    return $null
}

function Set-EnvValue {
    param(
        [string[]]$Lines,
        [string]$Key,
        [string]$Value
    )
    $updated = $false
    $result = @()
    foreach ($line in $Lines) {
        if ($line -match "^$Key=(.*)$") {
            $result += "$Key=$Value"
            $updated = $true
        } else {
            $result += $line
        }
    }
    if (-not $updated) {
        $result += "$Key=$Value"
    }
    return ,$result
}

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

# Build candidate myshopify hosts in deterministic order.
$hostOnly = Get-NormalizedHost $storeDomain
$candidateHosts = [System.Collections.Generic.List[string]]::new()
Add-HostCandidate -List $candidateHosts -Host $myshopifyDomain

if ($hostOnly -match '\.myshopify\.com$') {
    Add-HostCandidate -List $candidateHosts -Host $hostOnly
} elseif (-not [string]::IsNullOrWhiteSpace($hostOnly)) {
    # Custom domain fallback: first label + .myshopify.com (e.g. aodrop.com -> aodrop.myshopify.com).
    $storeLabel = ($hostOnly -split '\.')[0]
    if (-not [string]::IsNullOrWhiteSpace($storeLabel)) {
        Add-HostCandidate -List $candidateHosts -Host "$storeLabel.myshopify.com"
    }
    # Preserve legacy derivation as final fallback for older setups.
    Add-HostCandidate -List $candidateHosts -Host "$hostOnly.myshopify.com"
}

if ($candidateHosts.Count -eq 0) {
    Write-Host "Error: Could not determine a candidate myshopify domain for OAuth." -ForegroundColor Red
    Write-Host "Set SHOPIFY_MYSHOPIFY_DOMAIN in .env.local (example: your-store.myshopify.com)." -ForegroundColor Yellow
    exit 1
}

$body = @{
    grant_type    = "client_credentials"
    client_id     = $apiKey
    client_secret = $apiSecret
}
$attemptFailures = @()
$token = $null
$resolvedHost = $null

foreach ($oauthHost in $candidateHosts) {
    $uri = "https://$oauthHost/admin/oauth/access_token"
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Post -Body $body -ContentType "application/x-www-form-urlencoded" -TimeoutSec 30
        $token = $response.access_token
        if (-not [string]::IsNullOrWhiteSpace($token)) {
            $resolvedHost = $oauthHost
            break
        }
        $attemptFailures += "[$oauthHost] Empty access_token in response"
    } catch {
        $statusCode = $null
        try {
            if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
                $statusCode = [int]$_.Exception.Response.StatusCode
            }
        } catch {}
        $errorBody = Get-ErrorResponseBody $_
        $errorDetail = $_.Exception.Message
        if (-not [string]::IsNullOrWhiteSpace($errorBody)) {
            $errorDetail = "$errorDetail | $errorBody"
        }
        if ($statusCode) {
            $attemptFailures += "[$oauthHost] HTTP ${statusCode}: $errorDetail"
        } else {
            $attemptFailures += "[$oauthHost] $errorDetail"
        }
    }
}

if ([string]::IsNullOrWhiteSpace($token)) {
    Write-Host "Error: Unable to obtain access token from all candidate hosts." -ForegroundColor Red
    foreach ($failure in $attemptFailures) {
        Write-Host "  $failure" -ForegroundColor Yellow
    }
    exit 1
}

$content = Get-Content $envPath
$content = Set-EnvValue -Lines $content -Key "SHOPIFY_ACCESS_TOKEN" -Value $token
$content = Set-EnvValue -Lines $content -Key "SHOPIFY_CLI_THEME_TOKEN" -Value $token
if (-not [string]::IsNullOrWhiteSpace($resolvedHost)) {
    $content = Set-EnvValue -Lines $content -Key "SHOPIFY_MYSHOPIFY_DOMAIN" -Value $resolvedHost
}
$content | Out-File -FilePath $envPath -Encoding UTF8

Write-Host "[OK] Access token obtained and saved to .env.local." -ForegroundColor Green
Write-Host "[OK] OAuth host resolved: $resolvedHost" -ForegroundColor Green
Write-Host "Verify with: .\scripts\run-runbook.ps1" -ForegroundColor Cyan
