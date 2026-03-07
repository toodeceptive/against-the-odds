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

function Resolve-ShopifyStoreInfo {
    param(
        [string]$Store,
        [string]$MyShopifyDomain = $env:SHOPIFY_MYSHOPIFY_DOMAIN,
        [string]$StoreSlug = $(if ([string]::IsNullOrWhiteSpace($env:ATO_SHOPIFY_STORE_ID)) { $env:SHOPIFY_STORE_ID } else { $env:ATO_SHOPIFY_STORE_ID })
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
    $normalizedStoreSlug = if ([string]::IsNullOrWhiteSpace($StoreSlug)) {
        $null
    } else {
        $StoreSlug.Trim().ToLowerInvariant()
    }

    $knownStore = $knownStores[$storefrontHost]
    if (-not $knownStore -and -not [string]::IsNullOrWhiteSpace($explicitMyShopifyDomain)) {
        $knownStore = $knownStores[$explicitMyShopifyDomain]
    }

    $adminHost = $storefrontHost
    if ($storefrontHost -match '\.myshopify\.com$') {
        $adminHost = $storefrontHost
        if (-not $normalizedStoreSlug) {
            $normalizedStoreSlug = $storefrontHost -replace '\.myshopify\.com$', ''
        }
    } elseif (-not [string]::IsNullOrWhiteSpace($explicitMyShopifyDomain)) {
        $adminHost = $explicitMyShopifyDomain
        if (-not $normalizedStoreSlug -and $explicitMyShopifyDomain -match '\.myshopify\.com$') {
            $normalizedStoreSlug = $explicitMyShopifyDomain -replace '\.myshopify\.com$', ''
        }
    } elseif ($knownStore) {
        $adminHost = $knownStore.AdminHost
        if (-not $normalizedStoreSlug) {
            $normalizedStoreSlug = $knownStore.StoreSlug
        }
    }

    return [PSCustomObject]@{
        StorefrontHost = $storefrontHost
        AdminHost      = $adminHost
        CliHost        = $adminHost
        StoreSlug      = $normalizedStoreSlug
    }
}

function Get-ShopifyAdminUrl {
    param(
        [string]$Store,
        [string]$Path = "/",
        [string]$CurrentUrl = $null
    )

    $normalizedPath = if ([string]::IsNullOrWhiteSpace($Path)) { "/" } else { $Path.Trim() }
    if (-not $normalizedPath.StartsWith("/")) {
        $normalizedPath = "/$normalizedPath"
    }
    $normalizedPath = $normalizedPath -replace '^/admin(?=/|$)', ''
    if ([string]::IsNullOrWhiteSpace($normalizedPath)) {
        $normalizedPath = "/"
    }

    if (-not [string]::IsNullOrWhiteSpace($CurrentUrl)) {
        try {
            $current = [Uri]$CurrentUrl
            if ($current.Host -eq "admin.shopify.com" -and $current.AbsolutePath -match '^/store/([^/]+)') {
                return "https://admin.shopify.com/store/$($matches[1])$normalizedPath"
            }
        } catch {}
    }

    $storeInfo = Resolve-ShopifyStoreInfo -Store $Store
    if (-not [string]::IsNullOrWhiteSpace($storeInfo.StoreSlug)) {
        return "https://admin.shopify.com/store/$($storeInfo.StoreSlug)$normalizedPath"
    }

    $legacyPath = if ($normalizedPath -eq "/") { "/admin" } else { "/admin$normalizedPath" }
    return "https://$($storeInfo.AdminHost)$legacyPath"
}
