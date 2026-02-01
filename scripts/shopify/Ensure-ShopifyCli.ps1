# Ensures Shopify CLI is available; installs globally if missing.
# Dot-source from other shopify scripts. Sets $ShopifyCmd as array: ("shopify") or ("npx", "shopify").
# Invoke with: & $ShopifyCmd[0] ($ShopifyCmd[1..($ShopifyCmd.Length-1)] + "theme", "pull", ...)

if (Get-Command shopify -ErrorAction SilentlyContinue) {
    $ShopifyCmd = @("shopify")
    return
}

Write-Host "Shopify CLI not found. Installing @shopify/cli and @shopify/theme..." -ForegroundColor Yellow
& npm install -g @shopify/cli @shopify/theme
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to install Shopify CLI." -ForegroundColor Red
    exit 1
}
$ShopifyCmd = @("npx", "shopify")
