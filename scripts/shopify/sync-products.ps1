# Sync products from local data to Shopify
# Reads product data from data/products/ and syncs to Shopify store

param(
    [switch]$DryRun = $false,
    [string]$Store = $env:SHOPIFY_STORE_DOMAIN,
    [string]$Token = $env:SHOPIFY_ACCESS_TOKEN
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Shopify Product Sync ===" -ForegroundColor Cyan
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

# Check for product data directory
$productsDir = "data\products"
if (-not (Test-Path $productsDir)) {
    Write-Host "Creating products directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $productsDir | Out-Null
    Write-Host "✓ Created $productsDir" -ForegroundColor Green
    Write-Host "Add product JSON files to this directory to sync them." -ForegroundColor Yellow
    exit 0
}

# Get product files
$productFiles = Get-ChildItem -Path $productsDir -Filter "*.json"
if ($productFiles.Count -eq 0) {
    Write-Host "No product files found in $productsDir" -ForegroundColor Yellow
    exit 0
}

Write-Host "Found $($productFiles.Count) product file(s)" -ForegroundColor Cyan
Write-Host ""

# Setup API headers
$headers = @{
    "X-Shopify-Access-Token" = $Token
    "Content-Type" = "application/json"
}

$baseUrl = "https://$Store/admin/api/2024-01"

# Process each product file
foreach ($file in $productFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow
    
    try {
        $productData = Get-Content $file.FullName -Raw | ConvertFrom-Json
        
        if ($DryRun) {
            Write-Host "  [DRY RUN] Would create/update product: $($productData.title)" -ForegroundColor Cyan
            continue
        }
        
        # Check if product exists (by title or SKU)
        $existingProducts = Invoke-RestMethod -Uri "$baseUrl/products.json?title=$($productData.title)" `
            -Headers $headers -Method Get
        
        if ($existingProducts.products.Count -gt 0) {
            # Update existing product
            $productId = $existingProducts.products[0].id
            Write-Host "  Updating existing product (ID: $productId)..." -ForegroundColor Yellow
            
            $updateBody = @{
                product = $productData
            } | ConvertTo-Json -Depth 10
            
            $response = Invoke-RestMethod -Uri "$baseUrl/products/$productId.json" `
                -Headers $headers -Method Put -Body $updateBody
            
            Write-Host "  ✓ Updated: $($response.product.title)" -ForegroundColor Green
        } else {
            # Create new product
            Write-Host "  Creating new product..." -ForegroundColor Yellow
            
            $createBody = @{
                product = $productData
            } | ConvertTo-Json -Depth 10
            
            $response = Invoke-RestMethod -Uri "$baseUrl/products.json" `
                -Headers $headers -Method Post -Body $createBody
            
            Write-Host "  ✓ Created: $($response.product.title) (ID: $($response.product.id))" -ForegroundColor Green
        }
    } catch {
        Write-Host "  ✗ Error processing $($file.Name): $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "✓ Product sync complete!" -ForegroundColor Green
