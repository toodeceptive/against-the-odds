# Bug Fixes and Improvements

**Date**: January 28, 2026  
**Status**: ✅ All Critical Bugs Fixed

## Issues Found and Fixed

### 1. API Version Inconsistency ✅ FIXED

**Problem**: Some scripts were using API version `2024-01` instead of `2026-01` (matching Shopify app version).

**Files Fixed**:
- `scripts/shopify/sync-products.ps1` - Updated to `2026-01`
- `scripts/shopify/fetch-store-data.ps1` - Updated to `2026-01`

**Impact**: Scripts would fail or use incorrect API endpoints.

---

### 2. Variable Interpolation Bug ✅ FIXED

**Problem**: In `scripts/monitoring/performance-check.ps1`, variable interpolation was incorrect:
- `${response_time_ms}` should be `$($check.response_time_ms)`

**Lines Fixed**:
- Line 49: Site performance check
- Line 95: Shopify API check
- Line 145: GitHub API check

**Impact**: Performance reports would show incorrect or missing response times.

---

### 3. Pagination Logic Bug ✅ FIXED

**Problem**: In `scripts/products/export.ps1`, pagination logic was incorrect:
- Code tried to access `$response.PSObject.Properties['Link']?.Value` which doesn't exist
- Shopify API returns pagination in HTTP headers, not response body

**Fix**: Changed to use `Invoke-WebRequest` to access headers, then parse Link header correctly.

**Impact**: Export script would only fetch first page of products (250 max), missing additional products.

---

### 4. Missing Parameter Definitions ✅ FIXED

**Problem**: In `scripts/manufacturing/track-samples.ps1`, script referenced undefined parameters:
- `$ProductType`
- `$ExpectedDelivery`
- `$TrackingNumber`
- `$Notes`

**Fix**: Added all parameters to the `param()` block with appropriate defaults.

**Impact**: Script would fail when trying to add samples with these parameters.

---

### 5. Product Lookup Bug ✅ FIXED

**Problem**: In `scripts/shopify/sync-products.ps1`, code tried to search products using `?title=` query parameter, which Shopify API doesn't support.

**Fix**: Changed to fetch products and filter client-side by title.

**Impact**: Product sync would fail when trying to check if product exists, always creating duplicates.

---

### 6. Duplicate Catch Block ✅ FIXED

**Problem**: In `scripts/shopify/sync-products.ps1`, there were two catch blocks (duplicate error handling).

**Fix**: Removed duplicate and improved error message parsing.

**Impact**: Code would have unreachable duplicate error handling.

---

### 7. Filename Sanitization ✅ FIXED

**Problem**: In `scripts/products/export.ps1`, filenames could contain invalid characters for Windows filesystem.

**Fix**: Added sanitization to remove invalid characters (`<>:"/\|?*`) from product handles.

**Impact**: Export could fail on Windows if product handle contained invalid characters.

---

### 8. JSON Loading Error Handling ✅ FIXED

**Problem**: In `scripts/manufacturing/track-samples.ps1`, loading JSON could fail silently if file was corrupted or empty.

**Fix**: Added try-catch with proper error handling and array validation.

**Impact**: Script could crash or lose data if samples.json was corrupted.

---

### 9. Error Message Parsing ✅ IMPROVED

**Problem**: Error messages from Shopify API weren't being parsed properly.

**Fix**: Improved error handling to extract meaningful error messages from Shopify API responses.

**Impact**: Better error messages for debugging API issues.

---

## Testing Recommendations

After these fixes, test the following:

1. **Product Sync**:
   ```powershell
   .\scripts\shopify\sync-products.ps1 -DryRun
   ```

2. **Product Export**:
   ```powershell
   .\scripts\products\export.ps1
   ```

3. **Sample Tracking**:
   ```powershell
   .\scripts\manufacturing\track-samples.ps1 -Action add -Manufacturer "Test" -ProductType "Hoodie"
   ```

4. **Performance Monitoring**:
   ```powershell
   .\scripts\monitoring\performance-check.ps1
   ```

## Files Modified

- `scripts/shopify/sync-products.ps1` - 4 fixes
- `scripts/shopify/fetch-store-data.ps1` - 1 fix
- `scripts/products/export.ps1` - 2 fixes
- `scripts/manufacturing/track-samples.ps1` - 2 fixes
- `scripts/monitoring/performance-check.ps1` - 3 fixes

## Summary

✅ **9 bugs fixed**
✅ **All critical issues resolved**
✅ **Improved error handling**
✅ **Better compatibility with Shopify API**

All scripts should now work correctly with the Shopify 2026-01 API version and handle edge cases properly.
