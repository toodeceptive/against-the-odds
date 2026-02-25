# Extract Shopify Theme ID from Admin using Browser Automation

param(
    [string]$StoreDomain = $env:SHOPIFY_STORE_DOMAIN,
    [switch]$NoSave  # Omit to save to .env.local; use -NoSave to skip saving
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Shopify Theme ID Extraction ===" -ForegroundColor Cyan
Write-Host ""

if ([string]::IsNullOrWhiteSpace($StoreDomain)) {
    $StoreDomain = "aodrop.com"
}

# Check if Node.js is available
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Node.js not found." -ForegroundColor Red
    exit 1
}

# Create extraction script
$extractScript = @"
import { chromium } from '@playwright/test';
import { connectToBrowser, ensureShopifyLogin, extractThemeId } from '../../src/browser-automation/shopify-admin.js';

(async () => {
  try {
    const browser = await connectToBrowser({ useExisting: true, headless: false });
    const context = browser.contexts()[0] || await browser.newContext();
    const page = context.pages()[0] || await context.newPage();

    const loggedIn = await ensureShopifyLogin(page, '$StoreDomain');
    if (!loggedIn) {
      console.error('Failed to access Shopify admin');
      process.exit(1);
    }

    const themeId = await extractThemeId(page);

    if (themeId) {
      console.log('SUCCESS:' + themeId);
      process.exit(0);
    } else {
      console.error('Theme ID not found');
      process.exit(1);
    }
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
})();
"@

$scriptPath = "scripts\shopify\browser\extract-theme-temp.js"
$extractScript | Out-File -FilePath $scriptPath -Encoding UTF8

try {
    Write-Host "Extracting theme ID..." -ForegroundColor Yellow
    $output = node $scriptPath 2>&1
    $themeId = $null

    foreach ($line in $output) {
        if ($line -match 'SUCCESS:(.+)') {
            $themeId = $matches[1].Trim()
            break
        }
    }

    if ($themeId) {
        Write-Host "[OK] Theme ID extracted: $themeId" -ForegroundColor Green

        if (-not $NoSave -and (Test-Path ".env.local")) {
            $envContent = Get-Content ".env.local"
            $updated = $false
            $newContent = @()

            foreach ($line in $envContent) {
                if ($line -match '^SHOPIFY_THEME_ID=(.*)$') {
                    $newContent += "SHOPIFY_THEME_ID=$themeId"
                    $updated = $true
                } else {
                    $newContent += $line
                }
            }

            if (-not $updated) {
                $newContent += "SHOPIFY_THEME_ID=$themeId"
            }

            $newContent | Out-File -FilePath ".env.local" -Encoding UTF8
            Write-Host "[OK] Saved to .env.local" -ForegroundColor Green
        }
    } else {
        Write-Host "[FAIL] Could not extract theme ID" -ForegroundColor Red
    }
} finally {
    if (Test-Path $scriptPath) {
        Remove-Item $scriptPath -Force
    }
}

Write-Host ""
