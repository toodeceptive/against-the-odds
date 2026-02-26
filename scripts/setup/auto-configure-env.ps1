# Automated Environment Configuration Script
# Intelligently sets up .env.local with credential validation and secure storage

param(
    [switch]$Interactive = $true,
    [switch]$SkipValidation = $false
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== Automated Environment Configuration ===" -ForegroundColor Cyan
Write-Host ""

# Known non-secret defaults
$knownCredentials = @{
    SHOPIFY_STORE_DOMAIN = "aodrop.com"
    SHOPIFY_STORE_URL = "https://aodrop.com"
    GITHUB_USERNAME = "toodeceptive"
    GITHUB_REPO = "against-the-odds"
    NODE_ENV = "development"
    DEBUG = "false"
}

# Check if .env.local exists
$envLocalPath = ".env.local"
$envExists = Test-Path $envLocalPath

if ($envExists) {
    Write-Host ".env.local already exists." -ForegroundColor Yellow
    if ($Interactive) {
        $response = Read-Host "Backup and recreate? (y/n)"
        if ($response -eq "y") {
            $backupPath = ".env.local.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            Copy-Item $envLocalPath $backupPath
            Write-Host "[OK] Backed up to $backupPath" -ForegroundColor Green
        } else {
            Write-Host "Using existing .env.local" -ForegroundColor Cyan
            $envExists = $false  # Don't overwrite
        }
    }
}

# Create .env.local from template
if (-not $envExists) {
    if (Test-Path ".env.example") {
        Copy-Item ".env.example" $envLocalPath
        Write-Host "[OK] Created .env.local from .env.example" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] .env.example not found" -ForegroundColor Red
        exit 1
    }
}

# Read current .env.local
$envContent = Get-Content $envLocalPath
$envVars = @{}

# Parse existing environment variables
foreach ($line in $envContent) {
    if ($line -match '^([A-Z_]+)=(.*)$' -and -not $line.StartsWith('#')) {
        $varName = $matches[1]
        $varValue = $matches[2].Trim()
        $envVars[$varName] = $varValue
    }
}

# Apply known credentials
Write-Host ""
Write-Host "Applying known credentials..." -ForegroundColor Yellow
foreach ($key in $knownCredentials.Keys) {
    if ($envVars.ContainsKey($key)) {
        $envVars[$key] = $knownCredentials[$key]
        Write-Host "  [OK] Set $key" -ForegroundColor Green
    }
}

# --- Shopify access token: prefer client-credentials, else browser flow ---
$needShopifyToken = [string]::IsNullOrWhiteSpace($envVars['SHOPIFY_ACCESS_TOKEN']) -or $envVars['SHOPIFY_ACCESS_TOKEN'] -match 'your_.*_here'
$haveApiKeySecret = -not [string]::IsNullOrWhiteSpace($envVars['SHOPIFY_API_KEY']) -and $envVars['SHOPIFY_API_KEY'] -notmatch 'your_.*_here' `
    -and -not [string]::IsNullOrWhiteSpace($envVars['SHOPIFY_API_SECRET']) -and $envVars['SHOPIFY_API_SECRET'] -notmatch 'your_.*_here'

if ($needShopifyToken -and $haveApiKeySecret) {
    Write-Host ""
    Write-Host "SHOPIFY_ACCESS_TOKEN missing but API key/secret present. Obtaining token via client-credentials..." -ForegroundColor Cyan
    if (Test-Path "scripts\shopify\browser\get-token-client-credentials.ps1") {
        try {
            & "scripts\shopify\browser\get-token-client-credentials.ps1"
            $envContent = Get-Content $envLocalPath
            $envVars = @{}
            foreach ($line in $envContent) {
                if ($line -match '^([A-Z_]+)=(.*)$' -and -not $line.StartsWith('#')) {
                    $envVars[$matches[1]] = $matches[2].Trim()
                }
            }
            $needShopifyToken = $false
        } catch {
            Write-Host "  [WARN] Client-credentials failed: $_" -ForegroundColor Yellow
        }
    }
}

if ($needShopifyToken -and $Interactive) {
    Write-Host ""
    Write-Host "SHOPIFY_ACCESS_TOKEN is missing." -ForegroundColor Yellow
    Write-Host "  1. Run browser flow: open Shopify Admin (log in when asked), then run: .\scripts\shopify\browser\get-access-token.ps1" -ForegroundColor White
    Write-Host "  2. Or copy token from Admin → Apps → Development → API credentials, then: .\scripts\shopify\browser\save-token-to-env.ps1" -ForegroundColor White
    Write-Host "  3. Or enter manually below (option 1)." -ForegroundColor White
}

# --- Theme ID: optional browser extraction ---
$needThemeId = [string]::IsNullOrWhiteSpace($envVars['SHOPIFY_THEME_ID']) -or $envVars['SHOPIFY_THEME_ID'] -match 'your_.*_here'
if ($needThemeId -and $Interactive) {
    Write-Host ""
    $themeChoice = Read-Host "Get SHOPIFY_THEME_ID via browser now? (y/n; n = add later or use shopify theme list)"
    if ($themeChoice -eq "y" -and (Test-Path "scripts\shopify\browser\get-theme-id.ps1")) {
        & "scripts\shopify\browser\get-theme-id.ps1"
        $envContent = Get-Content $envLocalPath
        foreach ($line in $envContent) {
            if ($line -match '^SHOPIFY_THEME_ID=(.*)$') { $envVars['SHOPIFY_THEME_ID'] = $matches[1].Trim(); break }
        }
    }
}

# Missing credentials that need user input (excluding Shopify token if already obtained)
$missingCredentials = @()
if ($needShopifyToken) { $missingCredentials += "SHOPIFY_ACCESS_TOKEN" }
if ([string]::IsNullOrWhiteSpace($envVars['GITHUB_TOKEN']) -or $envVars['GITHUB_TOKEN'] -match 'your_.*_here') {
    $missingCredentials += "GITHUB_TOKEN"
}
if ($needThemeId -and ($envVars['SHOPIFY_THEME_ID'] -match 'your_.*_here' -or [string]::IsNullOrWhiteSpace($envVars['SHOPIFY_THEME_ID']))) {
    $missingCredentials += "SHOPIFY_THEME_ID"
}

# Prompt for missing credentials
if ($missingCredentials.Count -gt 0 -and $Interactive) {
    Write-Host ""
    Write-Host "Missing credentials:" -ForegroundColor Yellow
    foreach ($cred in $missingCredentials) {
        Write-Host "  - $cred" -ForegroundColor White
    }
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Cyan
    Write-Host "  1. Enter credentials manually" -ForegroundColor White
    Write-Host "  2. Use browser automation to extract (if Shopify is open)" -ForegroundColor White
    Write-Host "  3. Skip for now (you can add later)" -ForegroundColor White
    Write-Host "  GitHub token: create at https://github.com/settings/tokens" -ForegroundColor Gray
    Write-Host ""
    
    $choice = Read-Host "Choose option (1/2/3)"
    
    switch ($choice) {
        "1" {
            foreach ($cred in $missingCredentials) {
                $value = Read-Host "Enter $cred" -AsSecureString
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($value)
                $plainValue = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
                $envVars[$cred] = $plainValue
                Write-Host "  [OK] Set $cred" -ForegroundColor Green
            }
        }
        "2" {
            Write-Host "Attempting browser automation..." -ForegroundColor Yellow
            if (Test-Path "scripts\shopify\browser\get-access-token.ps1") {
                & "scripts\shopify\browser\get-access-token.ps1"
            } else {
                Write-Host "  [WARN] Browser automation script not found. Please enter manually." -ForegroundColor Yellow
            }
        }
        "3" {
            Write-Host "Skipping missing credentials. Add them later in .env.local" -ForegroundColor Yellow
        }
    }
}

# Write updated .env.local (re-read file in case sub-scripts updated it)
Write-Host ""
Write-Host "Writing .env.local..." -ForegroundColor Yellow
$envContent = Get-Content $envLocalPath
$newContent = @()
foreach ($line in $envContent) {
    if ($line -match '^([A-Z_]+)=(.*)$' -and -not $line.StartsWith('#')) {
        $varName = $matches[1]
        if ($envVars.ContainsKey($varName)) {
            $newContent += "$varName=$($envVars[$varName])"
        } else {
            $newContent += $line
        }
    } else {
        $newContent += $line
    }
}
$newContent | Out-File -FilePath $envLocalPath -Encoding UTF8
Write-Host "[OK] Updated .env.local" -ForegroundColor Green

# Optionally store in Windows Credential Manager
if ($Interactive) {
    Write-Host ""
    $response = Read-Host "Store credentials in Windows Credential Manager? (y/n)"
    if ($response -eq "y") {
        Write-Host "Storing credentials securely..." -ForegroundColor Yellow
        
        # Store GitHub token
        if ($envVars.ContainsKey('GITHUB_TOKEN') -and 
            -not [string]::IsNullOrWhiteSpace($envVars['GITHUB_TOKEN']) -and
            $envVars['GITHUB_TOKEN'] -notmatch 'your_.*_here') {
            try {
                cmdkey /generic:git:https://github.com /user:$($knownCredentials.GITHUB_USERNAME) /pass:$($envVars['GITHUB_TOKEN']) 2>&1 | Out-Null
                Write-Host "  [OK] Stored GitHub credentials" -ForegroundColor Green
            } catch {
                Write-Host "  [WARN] Could not store GitHub credentials: $_" -ForegroundColor Yellow
            }
        }
        
        # Store Shopify credentials
        if ($envVars.ContainsKey('SHOPIFY_ACCESS_TOKEN') -and 
            -not [string]::IsNullOrWhiteSpace($envVars['SHOPIFY_ACCESS_TOKEN']) -and
            $envVars['SHOPIFY_ACCESS_TOKEN'] -notmatch 'your_.*_here') {
            try {
                [System.Environment]::SetEnvironmentVariable('SHOPIFY_ACCESS_TOKEN', $envVars['SHOPIFY_ACCESS_TOKEN'], 'User')
                Write-Host "  [OK] Stored Shopify credentials" -ForegroundColor Green
            } catch {
                Write-Host "  [WARN] Could not store Shopify credentials: $_" -ForegroundColor Yellow
            }
        }
    }
}

# Validate credentials if not skipped
if (-not $SkipValidation) {
    Write-Host ""
    Write-Host "Validating credentials..." -ForegroundColor Yellow
    & "scripts\setup\verify-credentials.ps1" -Quiet
}

Write-Host ""
Write-Host "[OK] Environment configuration complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Run verification: .\scripts\setup\verify-credentials.ps1" -ForegroundColor White
Write-Host "2. Run full checks: .\scripts\run-runbook.ps1" -ForegroundColor White
Write-Host "3. (Optional) Review .env.local and test: .\scripts\shopify\test-connection.ps1" -ForegroundColor White
