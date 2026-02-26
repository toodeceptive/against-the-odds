# Verify GitHub Actions secrets configuration
param(
    [switch]$FailOnPermissionDenied
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) { (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path } else { (Get-Location).Path }
Set-Location $repoPath

Write-Host "=== GitHub Actions Secrets Verification ===" -ForegroundColor Cyan
Write-Host ""

# Required secrets for workflows (shopify-sync, etc.)
$requiredSecrets = @(
    "SHOPIFY_STORE_DOMAIN",
    "SHOPIFY_ACCESS_TOKEN"
)

# Optional secrets (theme dev, backups, etc.)
$optionalSecrets = @(
    "SHOPIFY_THEME_ID",
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

# Resolve GitHub CLI command, including default Windows install path.
$ghCommand = Get-Command gh -ErrorAction SilentlyContinue
if (-not $ghCommand) {
    $fallbackGhPath = "C:\Program Files\GitHub CLI\gh.exe"
    if (Test-Path $fallbackGhPath) {
        $ghCommand = $fallbackGhPath
    }
}

$strictFailure = $false

function Get-GitHubTokenFallback {
    foreach ($name in @("GH_TOKEN", "GITHUB_TOKEN")) {
        $v = [Environment]::GetEnvironmentVariable($name, "Process")
        if (-not [string]::IsNullOrWhiteSpace($v) -and $v -notmatch "your_.*_here") { return $v.Trim() }
    }
    $envPath = Join-Path $repoPath ".env.local"
    if (Test-Path $envPath) {
        foreach ($line in (Get-Content $envPath)) {
            if ($line -match "^\s*GITHUB_TOKEN\s*=\s*(.+)\s*$" -and -not $line.StartsWith("#")) {
                $t = $matches[1].Trim().Trim("'`"")
                if (-not [string]::IsNullOrWhiteSpace($t) -and $t -notmatch "your_.*_here") { return $t }
            }
        }
    }
    try {
        $out = "protocol=https`nhost=github.com`n`n" | git credential fill 2>$null
        $m = $out | Where-Object { $_ -like "password=*" } | Select-Object -First 1
        if ($m) { return $m.Substring(9).Trim() }
    } catch {}
    return $null
}

# Check if GitHub CLI is available
if ($ghCommand) {
    Write-Host "Checking secrets with GitHub CLI..." -ForegroundColor Yellow

    try {
        $authenticated = $false
        $null = & $ghCommand auth status 2>&1
        if ($LASTEXITCODE -eq 0) { $authenticated = $true }
        if (-not $authenticated) {
            $fb = Get-GitHubTokenFallback
            if ($fb) {
                $env:GH_TOKEN = $fb
                $null = & $ghCommand auth status 2>&1
                if ($LASTEXITCODE -eq 0) { $authenticated = $true }
            }
        }
        if (-not $authenticated) {
            Write-Host "  [WARN] GitHub CLI not authenticated" -ForegroundColor Yellow
            Write-Host "    Run: gh auth login (or set GITHUB_TOKEN)" -ForegroundColor Cyan
            if ($FailOnPermissionDenied) {
                $strictFailure = $true
            }
        } else {
            Write-Host "  [OK] GitHub CLI authenticated" -ForegroundColor Green

            # List secrets (explicit repo for GH_TOKEN / non-interactive)
            $secrets = & $ghCommand secret list --repo toodeceptive/against-the-odds 2>&1
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
                        if ($FailOnPermissionDenied) {
                            $strictFailure = $true
                        }
                    }
                }
            } else {
                Write-Host "  [WARN] Could not list secrets: $secrets" -ForegroundColor Yellow
                if ($FailOnPermissionDenied) {
                    $strictFailure = $true
                }
            }
        }
    } catch {
        Write-Host "  [FAIL] Error: $_" -ForegroundColor Red
        if ($FailOnPermissionDenied) {
            $strictFailure = $true
        }
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
    if ($FailOnPermissionDenied) {
        $strictFailure = $true
    }
}

Write-Host ""
Write-Host "For instructions, see: .github/workflows/README.md" -ForegroundColor Cyan

if ($FailOnPermissionDenied -and $strictFailure) {
    exit 1
}
