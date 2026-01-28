# Credential Verification Script
# Validates all configured credentials and API connections

param(
    [switch]$Quiet = $false
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

if (-not $Quiet) {
    Write-Host "=== Credential Verification ===" -ForegroundColor Cyan
    Write-Host ""
}

$results = @{
    github = @{ status = "unknown"; message = "" }
    shopify = @{ status = "unknown"; message = "" }
    environment = @{ status = "unknown"; message = "" }
}

# Check .env.local exists
$envLocalPath = ".env.local"
if (-not (Test-Path $envLocalPath)) {
    if (-not $Quiet) {
        Write-Host "✗ .env.local not found" -ForegroundColor Red
        Write-Host "Run: .\scripts\setup\auto-configure-env.ps1" -ForegroundColor Yellow
    }
    $results.environment.status = "missing"
    $results.environment.message = ".env.local not found"
    return $results
}

# Load environment variables
$envVars = @{}
$envContent = Get-Content $envLocalPath
foreach ($line in $envContent) {
    if ($line -match '^([A-Z_]+)=(.*)$' -and -not $line.StartsWith('#')) {
        $varName = $matches[1]
        $varValue = $matches[2].Trim()
        if (-not [string]::IsNullOrWhiteSpace($varValue) -and $varValue -notmatch 'your_.*_here') {
            $envVars[$varName] = $varValue
            [System.Environment]::SetEnvironmentVariable($varName, $varValue, 'Process')
        }
    }
}

$results.environment.status = "configured"
$results.environment.message = "Environment file loaded"

# Verify GitHub credentials
if (-not $Quiet) {
    Write-Host "Verifying GitHub credentials..." -ForegroundColor Yellow
}

$githubToken = $envVars['GITHUB_TOKEN']
$githubUsername = $envVars['GITHUB_USERNAME']
$githubRepo = $envVars['GITHUB_REPO']

if ([string]::IsNullOrWhiteSpace($githubToken) -or $githubToken -match 'your_.*_here') {
    $results.github.status = "missing"
    $results.github.message = "GITHUB_TOKEN not configured"
    if (-not $Quiet) {
        Write-Host "  ⚠ GITHUB_TOKEN not configured" -ForegroundColor Yellow
    }
} else {
    try {
        $headers = @{
            "Authorization" = "token $githubToken"
            "Accept" = "application/vnd.github.v3+json"
        }
        
        $response = Invoke-RestMethod -Uri "https://api.github.com/repos/$githubUsername/$githubRepo" `
            -Headers $headers -Method Get -TimeoutSec 10
        
        $results.github.status = "valid"
        $results.github.message = "Connected to repository: $($response.full_name)"
        if (-not $Quiet) {
            Write-Host "  ✓ GitHub credentials valid" -ForegroundColor Green
            Write-Host "    Repository: $($response.full_name)" -ForegroundColor Cyan
        }
    } catch {
        $results.github.status = "invalid"
        $results.github.message = "GitHub authentication failed: $($_.Exception.Message)"
        if (-not $Quiet) {
            Write-Host "  ✗ GitHub authentication failed" -ForegroundColor Red
            Write-Host "    Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

# Verify Shopify credentials
if (-not $Quiet) {
    Write-Host ""
    Write-Host "Verifying Shopify credentials..." -ForegroundColor Yellow
}

$shopifyStore = $envVars['SHOPIFY_STORE_DOMAIN']
$shopifyToken = $envVars['SHOPIFY_ACCESS_TOKEN']
$shopifyApiKey = $envVars['SHOPIFY_API_KEY']

if ([string]::IsNullOrWhiteSpace($shopifyStore) -or 
    [string]::IsNullOrWhiteSpace($shopifyToken) -or 
    $shopifyToken -match 'your_.*_here') {
    $results.shopify.status = "missing"
    $results.shopify.message = "Shopify credentials not fully configured"
    if (-not $Quiet) {
        Write-Host "  ⚠ Shopify credentials not fully configured" -ForegroundColor Yellow
    }
} else {
    try {
        $headers = @{
            "X-Shopify-Access-Token" = $shopifyToken
            "Content-Type" = "application/json"
        }
        
        $response = Invoke-RestMethod -Uri "https://$shopifyStore/admin/api/2026-01/shop.json" `
            -Headers $headers -Method Get -TimeoutSec 10
        
        $results.shopify.status = "valid"
        $results.shopify.message = "Connected to store: $($response.shop.name)"
        if (-not $Quiet) {
            Write-Host "  ✓ Shopify credentials valid" -ForegroundColor Green
            Write-Host "    Store: $($response.shop.name)" -ForegroundColor Cyan
            Write-Host "    Domain: $($response.shop.domain)" -ForegroundColor Cyan
        }
    } catch {
        $results.shopify.status = "invalid"
        $results.shopify.message = "Shopify authentication failed: $($_.Exception.Message)"
        if (-not $Quiet) {
            Write-Host "  ✗ Shopify authentication failed" -ForegroundColor Red
            Write-Host "    Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

# Summary
if (-not $Quiet) {
    Write-Host ""
    Write-Host "=== Verification Summary ===" -ForegroundColor Cyan
    Write-Host "Environment: $($results.environment.status) - $($results.environment.message)" -ForegroundColor $(if ($results.environment.status -eq "configured") { "Green" } else { "Red" })
    Write-Host "GitHub: $($results.github.status) - $($results.github.message)" -ForegroundColor $(if ($results.github.status -eq "valid") { "Green" } elseif ($results.github.status -eq "missing") { "Yellow" } else { "Red" })
    Write-Host "Shopify: $($results.shopify.status) - $($results.shopify.message)" -ForegroundColor $(if ($results.shopify.status -eq "valid") { "Green" } elseif ($results.shopify.status -eq "missing") { "Yellow" } else { "Red" })
    Write-Host ""
    
    $allValid = ($results.github.status -eq "valid" -or $results.github.status -eq "missing") -and 
                ($results.shopify.status -eq "valid" -or $results.shopify.status -eq "missing") -and
                $results.environment.status -eq "configured"
    
    if ($allValid) {
        Write-Host "✓ Credential verification complete!" -ForegroundColor Green
    } else {
        Write-Host "⚠ Some credentials need attention" -ForegroundColor Yellow
    }
}

return $results
