# Extract Shopify Access Token from Admin using Browser Automation
# Requires Playwright and existing Chrome instance with Shopify open

param(
    [string]$StoreDomain = $env:SHOPIFY_STORE_DOMAIN,
    [switch]$SaveToEnv = $true
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
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

# Create extraction script
$extractScript = @"
import { chromium } from '@playwright/test';
import { connectToBrowser, ensureShopifyLogin, extractAccessToken } from '../../src/browser-automation/shopify-admin.js';

(async () => {
  try {
    console.log('Connecting to browser...');
    const browser = await connectToBrowser({ useExisting: true, headless: false });
    const context = browser.contexts()[0] || await browser.newContext();
    const page = context.pages()[0] || await context.newPage();
    
    console.log('Navigating to Shopify admin...');
    const loggedIn = await ensureShopifyLogin(page, '$StoreDomain');
    
    if (!loggedIn) {
      console.error('Failed to access Shopify admin');
      process.exit(1);
    }
    
    console.log('Extracting access token...');
    const token = await extractAccessToken(page);
    
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
  }
})();
"@

$scriptPath = "scripts\shopify\browser\extract-token-temp.js"
$extractScript | Out-File -FilePath $scriptPath -Encoding UTF8

try {
    Write-Host "Running browser automation..." -ForegroundColor Yellow
    Write-Host "Please ensure Chrome is open with Shopify admin logged in." -ForegroundColor Cyan
    Write-Host ""
    
    $output = node $scriptPath 2>&1
    $token = $null
    
    foreach ($line in $output) {
        if ($line -match 'SUCCESS:(.+)') {
            $token = $matches[1].Trim()
            break
        }
        Write-Host $line
    }
    
    if ($token) {
        Write-Host ""
        Write-Host "✓ Access token extracted: $($token.Substring(0, 20))..." -ForegroundColor Green
        
        if ($SaveToEnv) {
            # Update .env.local
            if (Test-Path ".env.local") {
                $envContent = Get-Content ".env.local"
                $updated = $false
                $newContent = @()
                
                foreach ($line in $envContent) {
                    if ($line -match '^SHOPIFY_ACCESS_TOKEN=(.*)$') {
                        $newContent += "SHOPIFY_ACCESS_TOKEN=$token"
                        $updated = $true
                    } else {
                        $newContent += $line
                    }
                }
                
                if (-not $updated) {
                    $newContent += "SHOPIFY_ACCESS_TOKEN=$token"
                }
                
                $newContent | Out-File -FilePath ".env.local" -Encoding UTF8
                Write-Host "✓ Saved to .env.local" -ForegroundColor Green
            } else {
                Write-Host "⚠ .env.local not found. Token not saved." -ForegroundColor Yellow
                Write-Host "Token: $token" -ForegroundColor Cyan
            }
        } else {
            Write-Host "Token: $token" -ForegroundColor Cyan
        }
    } else {
        Write-Host ""
        Write-Host "✗ Could not extract access token automatically" -ForegroundColor Red
        Write-Host "Please extract manually from Shopify Admin > Apps > Development > Your App > API credentials" -ForegroundColor Yellow
    }
} catch {
    Write-Host ""
    Write-Host "✗ Error during extraction: $_" -ForegroundColor Red
    Write-Host "Please extract manually from Shopify Admin > Apps > Development" -ForegroundColor Yellow
} finally {
    # Cleanup temp script
    if (Test-Path $scriptPath) {
        Remove-Item $scriptPath -Force
    }
}

Write-Host ""
