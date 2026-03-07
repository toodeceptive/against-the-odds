function Get-NormalizedShopifyStoreHost {
    param(
        [string]$Store
    )

    if ([string]::IsNullOrWhiteSpace($Store)) {
        return $null
    }

    try {
        $trimmed = $Store.Trim()
        if ($trimmed -notmatch '^[a-z]+://') {
            $trimmed = "https://$trimmed"
        }
        return ([Uri]$trimmed).Host.ToLowerInvariant()
    } catch {
        return $null
    }
}

function Get-FallbackMyShopifyHost {
    param(
        [Parameter(Mandatory = $true)][string]$StorefrontHost,
        [string]$StoreSlug
    )

    if (-not [string]::IsNullOrWhiteSpace($StoreSlug)) {
        return "$StoreSlug.myshopify.com"
    }

    return "$StorefrontHost.myshopify.com"
}

function Resolve-ShopifyStoreInfo {
    param(
        [string]$Store,
        [string]$MyShopifyDomain = $env:SHOPIFY_MYSHOPIFY_DOMAIN,
        [string]$StoreSlug = $env:ATO_SHOPIFY_STORE_ID
    )

    $storefrontHost = Get-NormalizedShopifyStoreHost -Store $Store
    if ([string]::IsNullOrWhiteSpace($storefrontHost)) {
        return [PSCustomObject]@{
            StorefrontHost = $null
            AdminHost      = $null
            CliHost        = $null
            StoreSlug      = $null
        }
    }

    $knownStores = @{
        "aodrop.com" = @{
            AdminHost = "nbxwpf-z1.myshopify.com"
            StoreSlug = "nbxwpf-z1"
        }
        "nbxwpf-z1.myshopify.com" = @{
            AdminHost = "nbxwpf-z1.myshopify.com"
            StoreSlug = "nbxwpf-z1"
        }
    }

    $explicitMyShopifyDomain = Get-NormalizedShopifyStoreHost -Store $MyShopifyDomain
    $hasExplicitMyShopifyDomain = -not [string]::IsNullOrWhiteSpace($explicitMyShopifyDomain) -and $explicitMyShopifyDomain -match '\.myshopify\.com$'
    $normalizedStoreSlug = if ([string]::IsNullOrWhiteSpace($StoreSlug)) {
        $null
    } else {
        $StoreSlug.Trim().ToLowerInvariant()
    }

    $knownStore = $knownStores[$storefrontHost]
    if (-not $knownStore -and $hasExplicitMyShopifyDomain) {
        $knownStore = $knownStores[$explicitMyShopifyDomain]
    }

    $adminHost = $storefrontHost
    if ($storefrontHost -match '\.myshopify\.com$') {
        $adminHost = $storefrontHost
        if (-not $normalizedStoreSlug) {
            $normalizedStoreSlug = $storefrontHost -replace '\.myshopify\.com$', ''
        }
    } elseif ($hasExplicitMyShopifyDomain) {
        $adminHost = $explicitMyShopifyDomain
        if (-not $normalizedStoreSlug) {
            $normalizedStoreSlug = $explicitMyShopifyDomain -replace '\.myshopify\.com$', ''
        }
    } elseif ($knownStore) {
        $adminHost = $knownStore.AdminHost
        if (-not $normalizedStoreSlug) {
            $normalizedStoreSlug = $knownStore.StoreSlug
        }
    } else {
        $adminHost = Get-FallbackMyShopifyHost -StorefrontHost $storefrontHost -StoreSlug $normalizedStoreSlug
    }

    return [PSCustomObject]@{
        StorefrontHost = $storefrontHost
        AdminHost      = $adminHost
        CliHost        = $adminHost
        StoreSlug      = $normalizedStoreSlug
    }
}
