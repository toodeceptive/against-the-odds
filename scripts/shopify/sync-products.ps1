# Sync products from local data to Shopify
# Reads product data from data/products/ and syncs to Shopify store
# See docs/AGENT_WORKFLOW_CURSOR_SHOPIFY.md for preview/approval flow.
# API: https://shopify.dev/docs/api/admin-rest/latest/resources/product
# Rate limits: 2 req/s (standard); on 429 use Retry-After and backoff.

param(
    [switch]$DryRun = $false,
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$Token = $env:SHOPIFY_ACCESS_TOKEN
)

$ErrorActionPreference = "Stop"
. "$PSScriptRoot\ShopifyStoreHelpers.ps1"

# Repo root: script is scripts/shopify/sync-products.ps1 -> repo = parent of parent of PSScriptRoot
$repoPath = if ($PSScriptRoot) {
    $parent = Join-Path $PSScriptRoot ".."
    $grandParent = Join-Path $parent ".."
    (Resolve-Path $grandParent).Path
} else {
    Split-Path -Parent (Get-Location).Path
}
Set-Location $repoPath

# Load .env.local into process env when present (same pattern as test-connection.ps1)
if (Test-Path ".env.local") {
    Get-Content ".env.local" | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#") -and $line -match "^([^=]+)=(.*)$") {
            [Environment]::SetEnvironmentVariable($matches[1].Trim(), $matches[2].Trim(), "Process")
        }
    }
}
# Re-read from env after load (param binding runs before .env.local is loaded)
if ([string]::IsNullOrWhiteSpace($Store)) { $Store = $env:SHOPIFY_STORE_DOMAIN }
if ([string]::IsNullOrWhiteSpace($Token)) { $Token = $env:SHOPIFY_ACCESS_TOKEN }

Write-Host "=== Shopify Product Sync ===" -ForegroundColor Cyan
Write-Host ""

# Cross-platform products path
$productsDir = Join-Path (Join-Path $repoPath "data") "products"
if (-not (Test-Path $productsDir)) {
    Write-Host "Creating products directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $productsDir | Out-Null
    Write-Host "[OK] Created $productsDir" -ForegroundColor Green
    Write-Host "Add product JSON files to this directory to sync them." -ForegroundColor Yellow
    exit 0
}

# Get product files (exclude .gitkeep etc.)
$productFiles = Get-ChildItem -Path $productsDir -Filter "*.json" -File | Where-Object { $_.Name -notmatch '^\.' }
if (-not $productFiles -or $productFiles.Count -eq 0) {
    Write-Host "No product files found in $productsDir" -ForegroundColor Yellow
    exit 0
}

Write-Host "Found $($productFiles.Count) product file(s)" -ForegroundColor Cyan
Write-Host ""

$isApplyRun = -not $DryRun
if ($isApplyRun -and [string]::IsNullOrWhiteSpace($Store)) {
    Write-Host "Error: SHOPIFY_STORE_DOMAIN not set for apply run." -ForegroundColor Red
    Write-Host "Set it in .env.local or repo Secrets to enable sync." -ForegroundColor Yellow
    exit 1
}

if ($isApplyRun -and [string]::IsNullOrWhiteSpace($Token)) {
    Write-Host "Error: SHOPIFY_ACCESS_TOKEN not set for apply run." -ForegroundColor Red
    Write-Host "Set it in .env.local or repo Secrets to enable sync." -ForegroundColor Yellow
    exit 1
}

$baseUrl = $null
$headers = $null
if ($isApplyRun) {
    $storeInfo = Resolve-ShopifyStoreInfo -Store $Store
    $storeHost = $storeInfo.AdminHost
    $apiVersion = $env:SHOPIFY_ADMIN_API_VERSION
    if ([string]::IsNullOrWhiteSpace($apiVersion)) { $apiVersion = "2026-01" }

    $headers = @{
        "X-Shopify-Access-Token" = $Token
        "Content-Type"           = "application/json"
    }
    $baseUrl = "https://$storeHost/admin/api/$apiVersion"
}

function Test-ProductSchema {
    param([pscustomobject]$ProductData, [string]$FileName)

    $schemaVersion = 0
    if ($null -eq $ProductData.schema_version -or -not [long]::TryParse([string]$ProductData.schema_version, [ref]$schemaVersion)) {
        throw "Product file $FileName must declare a numeric schema_version."
    }

    $handle = [string]$ProductData.handle
    if ([string]::IsNullOrWhiteSpace($handle)) {
        throw "Product file $FileName must declare a non-empty handle."
    }

    if ($handle -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') {
        throw "Product file $FileName has invalid handle '$handle'. Use lowercase letters, numbers, and hyphens only."
    }
}

function Get-ShopifyProductPayload {
    param([pscustomobject]$ProductData)

    $payload = [ordered]@{}
    foreach ($property in $ProductData.PSObject.Properties) {
        if ($property.Name -ne "schema_version") {
            $payload[$property.Name] = $property.Value
        }
    }

    return $payload
}

# Invoke REST with 429 retry (Retry-After or 1s backoff, max 3 retries)
function Invoke-ShopifyRestMethod {
    param([string]$Uri, [hashtable]$Headers, [string]$Method = "Get", [string]$Body = $null)
    $maxRetries = 3
    $attempt = 0
    while ($true) {
        try {
            $params = @{ Uri = $Uri; Headers = $Headers; Method = $Method }
            if ($Body) { $params.Body = $Body }
            return Invoke-RestMethod @params
        } catch {
            $attempt++
            if ($attempt -ge $maxRetries) { throw }
            $statusCode = $null
            if ($_.Exception -and $_.Exception.Response -and $_.Exception.Response.StatusCode) {
                $statusCode = $_.Exception.Response.StatusCode.Value__
            }
            if ($statusCode -eq 429) {
                $retryAfter = 1
                $resp = $_.Exception.Response
                if ($resp -and $resp.Headers -and $resp.Headers["Retry-After"]) {
                    $retryAfter = [int][double]::Parse($resp.Headers["Retry-After"][0])
                }
                $retryAfter = [Math]::Max(1, [Math]::Min($retryAfter, 10))
                Write-Host "  [429] Rate limited; waiting ${retryAfter}s before retry ($attempt/$maxRetries)" -ForegroundColor Yellow
                Start-Sleep -Seconds $retryAfter
            } else {
                throw
            }
        }
    }
}

$processed = 0
$failed = 0
foreach ($file in $productFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow

    try {
        $productData = Get-Content $file.FullName -Raw | ConvertFrom-Json
        Test-ProductSchema -ProductData $productData -FileName $file.Name
        $productHandle = ([string]$productData.handle).Trim().ToLowerInvariant()
        $shopifyProductData = Get-ShopifyProductPayload -ProductData $productData

        if ($DryRun) {
            Write-Host "  [DRY RUN] Would create/update product: $($productData.title) (handle: $productHandle)" -ForegroundColor Cyan
            $processed++
            continue
        }

        $productFound = $false
        $productId = $null

        try {
            $searchUrl = "$baseUrl/products.json?handle=$([uri]::EscapeDataString($productHandle))&limit=1"
            $allProducts = Invoke-ShopifyRestMethod -Uri $searchUrl -Headers $headers -Method Get

            if ($allProducts.products) {
                $matchingProduct = $allProducts.products | Where-Object { $_.handle -eq $productHandle } | Select-Object -First 1
                if ($matchingProduct) {
                    $productFound = $true
                    $productId = $matchingProduct.id
                }
            }
        } catch {
            Write-Host "  [WARN] Could not check for existing products: $_" -ForegroundColor Yellow
        }

        if ($productFound -and $productId) {
            Write-Host "  Updating existing product (ID: $productId, handle: $productHandle)..." -ForegroundColor Yellow
            $updateBody = @{ product = $shopifyProductData } | ConvertTo-Json -Depth 10
            $response = Invoke-ShopifyRestMethod -Uri "$baseUrl/products/$productId.json" -Headers $headers -Method Put -Body $updateBody
            Write-Host "  [OK] Updated: $($response.product.title)" -ForegroundColor Green
        } else {
            Write-Host "  Creating new product (handle: $productHandle)..." -ForegroundColor Yellow
            $createBody = @{ product = $shopifyProductData } | ConvertTo-Json -Depth 10
            $response = Invoke-ShopifyRestMethod -Uri "$baseUrl/products.json" -Headers $headers -Method Post -Body $createBody
            Write-Host "  [OK] Created: $($response.product.title) (ID: $($response.product.id))" -ForegroundColor Green
        }
        $processed++
    } catch {
        $failed++
        $errorMessage = $_.Exception.Message
        if ($_.ErrorDetails.Message) {
            try {
                $errorDetails = $_.ErrorDetails.Message | ConvertFrom-Json
                if ($errorDetails.errors) {
                    $errorMessage = ($errorDetails.errors | ForEach-Object {
                        if ($_.message) { $_.message } else { $_ }
                    }) -join "; "
                }
            } catch { }
        }
        Write-Host "  ✗ Error processing $($file.Name): $errorMessage" -ForegroundColor Red
    }
}

Write-Host ""
if ($failed -gt 0) {
    Write-Host "[FAIL] Product sync finished with $failed failure(s) and $processed successful item(s)." -ForegroundColor Red
    exit 1
}

if ($DryRun) {
    Write-Host "[OK] Product sync dry run complete! ($processed item(s) validated)" -ForegroundColor Green
} else {
    Write-Host "[OK] Product sync complete! ($processed item(s) applied)" -ForegroundColor Green
}
