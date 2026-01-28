# Verify all platforms are synchronized

param(
    [switch]$AutoFix = $false
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Comprehensive Synchronization Verification ===" -ForegroundColor Cyan
Write-Host ""

$issues = @()
$warnings = @()

# Load shared utilities
$utilitiesPath = "scripts\shared\utilities.ps1"
if (Test-Path $utilitiesPath) {
    . $utilitiesPath
}

# 1. Git Repository Sync
Write-Host "1. Verifying Git repository synchronization..." -ForegroundColor Yellow
try {
    git fetch origin 2>&1 | Out-Null
    $localCommit = git rev-parse HEAD
    $remoteCommit = git rev-parse origin/main 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        if ($localCommit -eq $remoteCommit) {
            Write-Success "Git repository is synchronized"
        } else {
            $issue = "Git repository out of sync (local: $($localCommit.Substring(0,7)), remote: $($remoteCommit.Substring(0,7)))"
            $issues += $issue
            Write-Warning $issue
            
            if ($AutoFix) {
                Write-Host "  Attempting to sync..." -ForegroundColor Cyan
                git pull origin main 2>&1 | Out-Null
                if ($LASTEXITCODE -eq 0) {
                    Write-Success "Git repository synced"
                    $issues = $issues | Where-Object { $_ -ne $issue }
                }
            }
        }
    } else {
        $warnings += "Could not verify remote repository state"
        Write-Warning "Could not verify remote repository state"
    }
} catch {
    $issues += "Git verification failed: $_"
    Write-Warning "Git verification failed: $_"
}

# 2. Environment Configuration
Write-Host ""
Write-Host "2. Verifying environment configuration..." -ForegroundColor Yellow
if (Test-Path ".env.local") {
    Write-Success ".env.local exists"
    
    # Check for required variables
    $requiredVars = @("SHOPIFY_STORE_DOMAIN", "SHOPIFY_ACCESS_TOKEN")
    $envContent = Get-Content ".env.local"
    foreach ($var in $requiredVars) {
        $found = $false
        foreach ($line in $envContent) {
            if ($line -match "^$var=(.+)$" -and -not $line.StartsWith('#')) {
                $value = $matches[1].Trim()
                if (-not [string]::IsNullOrWhiteSpace($value) -and $value -notmatch 'your_.*_here') {
                    $found = $true
                    break
                }
            }
        }
        if (-not $found) {
            $warnings += "$var not configured in .env.local"
            Write-Warning "$var not configured"
        } else {
            Write-Success "$var is configured"
        }
    }
} else {
    $issues += ".env.local not found"
    Write-Warning ".env.local not found"
    
    if ($AutoFix) {
        Write-Host "  Creating .env.local from template..." -ForegroundColor Cyan
        if (Test-Path ".env.example") {
            Copy-Item ".env.example" ".env.local"
            Write-Success ".env.local created"
        }
    }
}

# 3. Shopify API Connectivity
Write-Host ""
Write-Host "3. Verifying Shopify API connectivity..." -ForegroundColor Yellow
$shopifyStore = Get-EnvVar "SHOPIFY_STORE_DOMAIN"
$shopifyToken = Get-EnvVar "SHOPIFY_ACCESS_TOKEN"

if (-not [string]::IsNullOrWhiteSpace($shopifyStore) -and 
    -not [string]::IsNullOrWhiteSpace($shopifyToken) -and
    $shopifyToken -notmatch 'your_.*_here') {
    if (Test-ShopifyCredentials -Store $shopifyStore -Token $shopifyToken) {
        Write-Success "Shopify API is accessible"
    } else {
        $issues += "Shopify API connection failed"
        Write-Warning "Shopify API connection failed"
    }
} else {
    $warnings += "Shopify credentials not configured"
    Write-Warning "Shopify credentials not configured"
}

# 4. GitHub API Connectivity
Write-Host ""
Write-Host "4. Verifying GitHub API connectivity..." -ForegroundColor Yellow
$githubToken = Get-EnvVar "GITHUB_TOKEN"

if (-not [string]::IsNullOrWhiteSpace($githubToken) -and $githubToken -notmatch 'your_.*_here') {
    if (Test-GitHubCredentials -Token $githubToken) {
        Write-Success "GitHub API is accessible"
    } else {
        $issues += "GitHub API connection failed"
        Write-Warning "GitHub API connection failed"
    }
} else {
    $warnings += "GitHub token not configured"
    Write-Warning "GitHub token not configured"
}

# 5. Local File Structure
Write-Host ""
Write-Host "5. Verifying local file structure..." -ForegroundColor Yellow
$requiredDirs = @("scripts", "docs", "data", "tests", ".github")
foreach ($dir in $requiredDirs) {
    if (Test-Path $dir) {
        Write-Success "$dir directory exists"
    } else {
        $issues += "Required directory missing: $dir"
        Write-Warning "Required directory missing: $dir"
    }
}

# Summary
Write-Host ""
Write-Host "=== Verification Summary ===" -ForegroundColor Cyan
Write-Host "Issues found: $($issues.Count)" -ForegroundColor $(if ($issues.Count -eq 0) { "Green" } else { "Red" })
Write-Host "Warnings: $($warnings.Count)" -ForegroundColor $(if ($warnings.Count -eq 0) { "Green" } else { "Yellow" })

if ($issues.Count -gt 0) {
    Write-Host ""
    Write-Host "Issues:" -ForegroundColor Red
    foreach ($issue in $issues) {
        Write-Host "  - $issue" -ForegroundColor Red
    }
}

if ($warnings.Count -gt 0) {
    Write-Host ""
    Write-Host "Warnings:" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "  - $warning" -ForegroundColor Yellow
    }
}

if ($issues.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host ""
    Write-Success "All systems synchronized and operational!"
    exit 0
} elseif ($issues.Count -eq 0) {
    Write-Host ""
    Write-Warning "Some warnings found, but no critical issues"
    exit 0
} else {
    Write-Host ""
    Write-Host "Run with -AutoFix to attempt automatic fixes" -ForegroundColor Cyan
    exit 1
}
