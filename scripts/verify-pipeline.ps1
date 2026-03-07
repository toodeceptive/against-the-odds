# Verify Cursor-GitHub-Shopify pipeline: scripts parse, workflows present, theme export verifies, and strict mode expands into integration/smoke checks.
# Run from repo root: .\scripts\verify-pipeline.ps1

param(
    [switch]$SkipRunbook = $false,
    [switch]$SkipParse = $false,
    [switch]$RequireRunbook = $false
)

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
    (Get-Location).Path
}
Set-Location $repoPath

$failed = 0

Write-Host "=== Pipeline verification ===" -ForegroundColor Cyan
Write-Host ""

# 1. Parse PowerShell scripts
if (-not $SkipParse) {
    Write-Host "[1/6] Parsing PowerShell scripts..." -ForegroundColor Yellow
    $parseScript = Join-Path $repoPath (Join-Path "scripts" (Join-Path "debug" "parse-all-ps1.ps1"))
    if (Test-Path $parseScript) {
        & $parseScript
        if ($LASTEXITCODE -ne 0) { $failed++ }
    } else {
        Write-Host "  (parse-all-ps1.ps1 not found, skip)" -ForegroundColor Gray
    }
    Write-Host ""
}

# 2. Workflow files exist
Write-Host "[2/6] Checking workflow files..." -ForegroundColor Yellow
$workflows = @(
    ".github/workflows/ci.yml",
    ".github/workflows/codeql.yml",
    ".github/workflows/governance-verify.yml",
    ".github/workflows/shopify-sync.yml",
    ".github/workflows/sync-theme-branch.yml",
    ".github/workflows/sync.yml",
    ".github/workflows/maintenance.yml"
)
foreach ($w in $workflows) {
    $fullPath = Join-Path $repoPath $w
    if (Test-Path $fullPath) {
        Write-Host "  OK $w" -ForegroundColor Green
    } else {
        Write-Host "  MISSING $w" -ForegroundColor Red
        $failed++
    }
}
Write-Host ""

# 3. Theme branch export verification
Write-Host "[3/6] Verifying theme branch export..." -ForegroundColor Yellow
if (Test-Path (Join-Path $repoPath "package.json")) {
    node "scripts/shopify/verify-theme-branch.mjs"
    if ($LASTEXITCODE -ne 0) {
        $failed++
    }
} else {
    Write-Host "  (no package.json, skip)" -ForegroundColor Gray
}
Write-Host ""

# 4. Product sync dry-run (if env has Shopify creds)
Write-Host "[4/6] Product sync dry-run (if .env.local has Shopify creds)..." -ForegroundColor Yellow
$envPath = Join-Path $repoPath ".env.local"
if (Test-Path $envPath) {
    Get-Content $envPath | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#") -and $line -match "^([^=]+)=(.*)$") {
            [Environment]::SetEnvironmentVariable($matches[1].Trim(), $matches[2].Trim(), "Process")
        }
    }
}
$store = [Environment]::GetEnvironmentVariable("SHOPIFY_STORE_DOMAIN", "Process")
$token = [Environment]::GetEnvironmentVariable("SHOPIFY_ACCESS_TOKEN", "Process")
if ($store -and $token) {
    $syncScript = Join-Path $repoPath (Join-Path "scripts" (Join-Path "shopify" "sync-products.ps1"))
    & $syncScript -DryRun
    if ($LASTEXITCODE -ne 0) { $failed++ }
} else {
    Write-Host "  (SHOPIFY_STORE_DOMAIN or SHOPIFY_ACCESS_TOKEN not set, skip dry-run)" -ForegroundColor Gray
}
Write-Host ""

# 5. Quality gate
Write-Host "[5/6] Repo quality gate..." -ForegroundColor Yellow
if (Test-Path (Join-Path $repoPath "package.json")) {
    npm run quality 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Quality gate reported issues." -ForegroundColor Red
        $failed++
    } else {
        Write-Host "  OK" -ForegroundColor Green
    }
} else {
    Write-Host "  (no package.json, skip)" -ForegroundColor Gray
}
Write-Host ""

# 6. Strict-only integration + runbook checks
if (-not $SkipRunbook) {
    Write-Host "[6/6] Strict verification extras..." -ForegroundColor Yellow
    if ($RequireRunbook -and (Test-Path (Join-Path $repoPath "package.json"))) {
        Write-Host "  Running integration tests..." -ForegroundColor Yellow
        npm run test:integration 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  Integration tests reported issues." -ForegroundColor Red
            $failed++
        } else {
            Write-Host "  Integration tests OK" -ForegroundColor Green
        }

        Write-Host "  Running local E2E smoke..." -ForegroundColor Yellow
        npm run test:e2e:smoke 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  E2E smoke reported issues." -ForegroundColor Red
            $failed++
        } else {
            Write-Host "  E2E smoke OK" -ForegroundColor Green
        }

        $governanceToken = [Environment]::GetEnvironmentVariable("GITHUB_ADMIN_TOKEN", "Process")
        if ([string]::IsNullOrWhiteSpace($governanceToken)) {
            Write-Host "  (GITHUB_ADMIN_TOKEN not set, skip governance verification)" -ForegroundColor Gray
        } else {
            Write-Host "  Verifying governance settings..." -ForegroundColor Yellow
            npm run verify:governance 2>&1 | Out-Null
            if ($LASTEXITCODE -ne 0) {
                Write-Host "  Governance verification reported issues." -ForegroundColor Red
                $failed++
            } else {
                Write-Host "  Governance settings OK" -ForegroundColor Green
            }
        }
    } elseif (-not $RequireRunbook) {
        Write-Host "  (integration, E2E smoke, and governance verification run in strict mode only; use -RequireRunbook)" -ForegroundColor Gray
    }

    $runbook = Join-Path $repoPath (Join-Path "scripts" "run-runbook.ps1")
    if (-not $RequireRunbook -and -not $token) {
        Write-Host "  (credential-gated: SHOPIFY_ACCESS_TOKEN not set, skip runbook; use -RequireRunbook for strict mode)" -ForegroundColor Gray
    } elseif (Test-Path $runbook) {
        & $runbook -StrictSecrets:$RequireRunbook
        if ($LASTEXITCODE -ne 0) { $failed++ }
    } else {
        Write-Host "  (run-runbook.ps1 not found, skip)" -ForegroundColor Gray
    }
} else {
    Write-Host "[6/6] Runbook skipped (use -SkipRunbook to skip)." -ForegroundColor Gray
}

Write-Host ""
if ($failed -gt 0) {
    Write-Host "Verification finished with $failed failure(s)." -ForegroundColor Red
    exit 1
}
Write-Host "Verification passed." -ForegroundColor Green
exit 0
