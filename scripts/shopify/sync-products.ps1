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

# Repo root: script is scripts/shopify/sync-products.ps1 -> repo = parent of parent of PSScriptRoot
$repoPath = if ($PSScriptRoot) {
    $parent = Join-Path $PSScriptRoot ".."
    $grandParent = Join-Path $parent ".."
    (Resolve-Path $grandParent).Path
} else {
    Split-Path -Parent (Get-Location).Path
}
Set-Location $repoPath

Write-Host "=== Shopify Product Sync ===" -ForegroundColor Cyan
Write-Host ""

# Validate environment — skip sync gracefully in CI when secrets are not set
if ([string]::IsNullOrWhiteSpace($Store)) {
    Write-Host "SHOPIFY_STORE_DOMAIN not set; skipping product sync." -ForegroundColor Yellow
    Write-Host "Set it in .env.local or repo Secrets to enable sync." -ForegroundColor Gray
    exit 0
}

if ([string]::IsNullOrWhiteSpace($Token)) {
    Write-Host "SHOPIFY_ACCESS_TOKEN not set; skipping product sync." -ForegroundColor Yellow
    Write-Host "Set it in .env.local or repo Secrets to enable sync." -ForegroundColor Gray
    exit 0
}

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

$headers = @{
    "X-Shopify-Access-Token" = $Token
    "Content-Type"           = "application/json"
}
$baseUrl = "https://$Store/admin/api/2024-10"

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

foreach ($file in $productFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow

    try {
        $productData = Get-Content $file.FullName -Raw | ConvertFrom-Json

        if ($DryRun) {
            Write-Host "  [DRY RUN] Would create/update product: $($productData.title)" -ForegroundColor Cyan
            continue
        }

        $productFound = $false
        $productId = $null

        try {
            $searchUrl = "$baseUrl/products.json?limit=250"
            $allProducts = Invoke-ShopifyRestMethod -Uri $searchUrl -Headers $headers -Method Get

            if ($allProducts.products) {
                $matchingProduct = $allProducts.products | Where-Object { $_.title -eq $productData.title }
                if ($matchingProduct) {
                    $productFound = $true
                    $productId = $matchingProduct.id
                }
            }
        } catch {
            Write-Host "  [WARN] Could not check for existing products: $_" -ForegroundColor Yellow
        }

        if ($productFound -and $productId) {
            Write-Host "  Updating existing product (ID: $productId)..." -ForegroundColor Yellow
            $updateBody = @{ product = $productData } | ConvertTo-Json -Depth 10
            $response = Invoke-ShopifyRestMethod -Uri "$baseUrl/products/$productId.json" -Headers $headers -Method Put -Body $updateBody
            Write-Host "  [OK] Updated: $($response.product.title)" -ForegroundColor Green
        } else {
            Write-Host "  Creating new product..." -ForegroundColor Yellow
            $createBody = @{ product = $productData } | ConvertTo-Json -Depth 10
            $response = Invoke-ShopifyRestMethod -Uri "$baseUrl/products.json" -Headers $headers -Method Post -Body $createBody
            Write-Host "  [OK] Created: $($response.product.title) (ID: $($response.product.id))" -ForegroundColor Green
        }
    } catch {
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
Write-Host "[OK] Product sync complete!" -ForegroundColor Green
