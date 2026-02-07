# Verify GitHub Actions secrets configuration

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== GitHub Actions Secrets Verification ===" -ForegroundColor Cyan
Write-Host ""

# Required secrets for workflows
$requiredSecrets = @(
    "SHOPIFY_STORE_DOMAIN",
    "SHOPIFY_ACCESS_TOKEN",
    "SHOPIFY_THEME_ID"
)

# Optional secrets
$optionalSecrets = @(
    "SHOPIFY_API_KEY",
    "SHOPIFY_API_SECRET",
    "GITHUB_TOKEN",
    "CLOUDFLARE_API_TOKEN"
)

Write-Host "Required Secrets:" -ForegroundColor Yellow
foreach ($secret in $requiredSecrets) {
    Write-Host "  - $secret" -ForegroundColor White
}

Write-Host ""
Write-Host "Optional Secrets:" -ForegroundColor Yellow
foreach ($secret in $optionalSecrets) {
    Write-Host "  - $secret" -ForegroundColor Gray
}

Write-Host ""

# Check if GitHub CLI is available
if (Get-Command gh -ErrorAction SilentlyContinue) {
    Write-Host "Checking secrets with GitHub CLI..." -ForegroundColor Yellow
    
    try {
        # Verify authentication
        $authStatus = gh auth status 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  [WARN] GitHub CLI not authenticated" -ForegroundColor Yellow
            Write-Host "    Run: gh auth login" -ForegroundColor Cyan
        } else {
            Write-Host "  [OK] GitHub CLI authenticated" -ForegroundColor Green
            
            # List secrets
            $secrets = gh secret list 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host ""
                Write-Host "Configured secrets:" -ForegroundColor Cyan
                $secrets | ForEach-Object { Write-Host "  $_" -ForegroundColor White }
                
                # Check for required secrets
                Write-Host ""
                Write-Host "Verifying required secrets..." -ForegroundColor Yellow
                foreach ($secret in $requiredSecrets) {
                    $found = $secrets | Select-String $secret
                    if ($found) {
                        Write-Host "  [OK] $secret configured" -ForegroundColor Green
                    } else {
                        Write-Host "  [FAIL] $secret missing" -ForegroundColor Red
                    }
                }
            } else {
                Write-Host "  [WARN] Could not list secrets: $secrets" -ForegroundColor Yellow
            }
        }
    } catch {
        Write-Host "  [FAIL] Error: $_" -ForegroundColor Red
    }
} else {
    Write-Host "GitHub CLI (gh) not installed" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Installation options:" -ForegroundColor Cyan
    Write-Host "  1. winget install GitHub.cli" -ForegroundColor White
    Write-Host "  2. Download from: https://cli.github.com/" -ForegroundColor White
    Write-Host ""
    Write-Host "Or check manually:" -ForegroundColor Cyan
    Write-Host "  https://github.com/toodeceptive/against-the-odds/settings/secrets/actions" -ForegroundColor White
    Write-Host ""
    Write-Host "Required secrets to configure:" -ForegroundColor Yellow
    foreach ($secret in $requiredSecrets) {
        Write-Host "  - $secret" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "For instructions, see: .github/workflows/README.md" -ForegroundColor Cyan
