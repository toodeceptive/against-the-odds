# Export products from Shopify to local data files

param(
    [string]$OutputDir = "data\products",
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$Token = $env:SHOPIFY_ACCESS_TOKEN,
    [switch]$AllProducts = $false
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Shopify Product Export ===" -ForegroundColor Cyan
Write-Host ""

# Validate environment
if ([string]::IsNullOrWhiteSpace($Store)) {
    Write-Host "Error: SHOPIFY_STORE_DOMAIN not set" -ForegroundColor Red
    Write-Host "Set it in .env.local or pass -Store parameter" -ForegroundColor Yellow
    exit 1
}

if ([string]::IsNullOrWhiteSpace($Token)) {
    Write-Host "Error: SHOPIFY_ACCESS_TOKEN not set" -ForegroundColor Red
    Write-Host "Set it in .env.local or pass -Token parameter" -ForegroundColor Yellow
    exit 1
}

# Ensure output directory exists
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
    Write-Host "[OK] Created output directory: $OutputDir" -ForegroundColor Green
}

# Setup API headers
$headers = @{
    "X-Shopify-Access-Token" = $Token
    "Content-Type" = "application/json"
}

$baseUrl = "https://$Store/admin/api/2026-01"
$products = @()
$pageInfo = $null
$hasNextPage = $true

Write-Host "Fetching products from Shopify..." -ForegroundColor Yellow

# Paginate through all products
while ($hasNextPage) {
    $url = "$baseUrl/products.json?limit=250"
    if ($pageInfo) {
        $url += "&page_info=$pageInfo"
    }
    
    try {
        $response = Invoke-WebRequest -Uri $url -Headers $headers -Method Get -UseBasicParsing
        
        # Parse response body
        $responseBody = $response.Content | ConvertFrom-Json
        
        if ($responseBody.products) {
            $products += $responseBody.products
            Write-Host "  Fetched $($responseBody.products.Count) products..." -ForegroundColor Cyan
        }
        
        # Check for next page in Link header
        $linkHeader = $response.Headers['Link']
        if ($linkHeader -and $linkHeader -match 'rel="next"') {
            if ($linkHeader -match 'page_info=([^>]+)') {
                $pageInfo = $matches[1]
            } else {
                $hasNextPage = $false
            }
        } else {
            $hasNextPage = $false
        }
    } catch {
        Write-Host "  Error fetching products: $_" -ForegroundColor Red
        $hasNextPage = $false
    }
}

Write-Host "Total products fetched: $($products.Count)" -ForegroundColor Green
Write-Host ""

# Export each product to JSON file
$exported = 0
foreach ($product in $products) {
    # Sanitize filename to avoid invalid characters
    $safeHandle = if ($product.handle) { $product.handle } else { "product" }
    $safeHandle = $safeHandle -replace '[<>:"/\\|?*]', '_'
    $filename = "$OutputDir\$($product.id)-$safeHandle.json"
    
    # Clean product data for export
    $exportData = @{
        title = $product.title
        body_html = $product.body_html
        vendor = $product.vendor
        product_type = $product.product_type
        tags = $product.tags
        status = $product.status
        variants = $product.variants | ForEach-Object {
            @{
                title = $_.title
                price = $_.price
                sku = $_.sku
                barcode = $_.barcode
                inventory_quantity = $_.inventory_quantity
                weight = $_.weight
                weight_unit = $_.weight_unit
                option1 = $_.option1
                option2 = $_.option2
                option3 = $_.option3
            }
        }
        images = $product.images | ForEach-Object {
            @{
                src = $_.src
                alt = $_.alt
            }
        }
        options = $product.options
    }
    
    $exportData | ConvertTo-Json -Depth 10 | Out-File -FilePath $filename -Encoding UTF8
    $exported++
    Write-Host "  [OK] Exported: $($product.title)" -ForegroundColor Green
}

Write-Host ""
Write-Host "[OK] Exported $exported products to $OutputDir" -ForegroundColor Green
