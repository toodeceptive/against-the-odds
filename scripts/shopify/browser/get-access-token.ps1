# Extract Shopify Access Token from Admin using Browser Automation
# Requires Playwright and existing Chrome instance with Shopify open

param(
    [string]$StoreDomain = $env:SHOPIFY_STORE_DOMAIN,
    [switch]$NoSave  # Omit to save to .env.local; use -NoSave to skip saving
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) {
    (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
} else {
    (Get-Location).Path
}
Set-Location $repoPath

Write-Host "=== Shopify Access Token Extraction ===" -ForegroundColor Cyan
Write-Host ""

if ([string]::IsNullOrWhiteSpace($StoreDomain)) {
    $StoreDomain = "aodrop.com"
    Write-Host "Using default store: $StoreDomain" -ForegroundColor Yellow
}

# Check if Node.js and Playwright are available
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Node.js not found. Please install Node.js first." -ForegroundColor Red
    exit 1
}

# Create extraction script (temp file outside repo to avoid token exposure in repo path)
$scriptPath = Join-Path $env:TEMP ("extract-token-" + [guid]::NewGuid().ToString("N") + ".mjs")
$extractScript = @"
import { join } from 'path';
import { pathToFileURL } from 'url';
const repoRoot = process.env.ATO_REPO_ROOT || process.cwd();
const modulePath = pathToFileURL(join(repoRoot, 'src', 'browser-automation', 'shopify-admin.js')).href;
const { connectToBrowser, ensureShopifyLogin, extractAccessToken, getConnectedBrowserPage } = await import(modulePath);

(async () => {
  let browser = null;
  let cleanup = async () => {};
  try {
    console.log('Connecting to browser...');
    browser = await connectToBrowser({ useExisting: true, headless: false });
    const connection = await getConnectedBrowserPage(browser, { storeDomain: '$StoreDomain' });
    const page = connection.page;
    cleanup = connection.cleanup;

    console.log('Navigating to Shopify admin...');
    const loggedIn = await ensureShopifyLogin(page, '$StoreDomain');

    if (!loggedIn) {
      console.error('Failed to access Shopify admin');
      process.exit(1);
    }

    console.log('Extracting access token...');
    const token = await extractAccessToken(page, '$StoreDomain');

    if (token) {
      console.log('SUCCESS:' + token);
      process.exit(0);
    } else {
      console.error('Access token not found. Please check manually in Shopify Admin > Apps > Development');
      process.exit(1);
    }
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  } finally {
    await cleanup().catch(() => {});
    if (browser) {
      await browser.close().catch(() => {});
    }
  }
})();
"@
$extractScript | Out-File -FilePath $scriptPath -Encoding UTF8

try {
    Write-Host "Running browser automation..." -ForegroundColor Yellow
    Write-Host "Please ensure Chrome is open with Shopify admin logged in." -ForegroundColor Cyan
    Write-Host ""

    $env:ATO_REPO_ROOT = $repoPath
    $output = node $scriptPath 2>&1
    $env:ATO_REPO_ROOT = $null
    $token = $null

    foreach ($line in $output) {
        if ($line -match 'SUCCESS:(.+)') {
            $token = $matches[1].Trim()
            break
        }
        if ($line -notmatch '^SUCCESS:') {
            Write-Host $line
        }
    }

    if ($token) {
        Write-Host ""
        Write-Host "[OK] Access token extracted." -ForegroundColor Green
        $env:ATO_SHOPIFY_STORE_ID = $null

        if (-not $NoSave) {
            # Update .env.local with the Admin API access token for API/REST-based scripts.
            if (Test-Path ".env.local") {
                $envContent = Get-Content ".env.local"
                $updatedAccess = $false
                $newContent = @()

                foreach ($line in $envContent) {
                    if ($line -match '^SHOPIFY_ACCESS_TOKEN=(.*)$') {
                        $newContent += "SHOPIFY_ACCESS_TOKEN=$token"
                        $updatedAccess = $true
                    } else {
                        $newContent += $line
                    }
                }

                if (-not $updatedAccess) { $newContent += "SHOPIFY_ACCESS_TOKEN=$token" }

                $newContent | Out-File -FilePath ".env.local" -Encoding UTF8
                Write-Host "[OK] Saved SHOPIFY_ACCESS_TOKEN to .env.local" -ForegroundColor Green
                Write-Host "[INFO] This Admin API token is for API/REST flows only. Use SHOPIFY_CLI_THEME_TOKEN or interactive Shopify CLI login for non-interactive theme dev/push." -ForegroundColor Cyan
            } else {
                Write-Host "[WARN] .env.local not found. Token not saved." -ForegroundColor Yellow
                Write-Host "Token obtained but not saved. Ensure .env.local exists and run again without -NoSave, or paste the token from Shopify Admin into .env.local." -ForegroundColor Cyan
            }
        } else {
            Write-Host "Token obtained (not saved). Run without -NoSave to write to .env.local, or paste from Shopify Admin > Apps > Development > API credentials." -ForegroundColor Cyan
        }
    } else {
        Write-Host ""
        Write-Host "✗ Could not extract access token automatically" -ForegroundColor Red
        Write-Host "Please extract manually from Shopify Admin > Apps > Development > Your App > API credentials" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host ""
    Write-Host "✗ Error during extraction: $_" -ForegroundColor Red
    Write-Host "Please extract manually from Shopify Admin > Apps > Development" -ForegroundColor Yellow
    exit 1
} finally {
    # Cleanup temp script
    if (Test-Path $scriptPath) {
        Remove-Item $scriptPath -Force
    }
}

Write-Host ""
