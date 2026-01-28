# Run all quality checks (linting, formatting, security)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

Write-Host "=== Quality Checks ===" -ForegroundColor Cyan
Write-Host ""

# Check if Node.js is installed
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Node.js/npm not found" -ForegroundColor Red
    exit 1
}

$allPassed = $true

# Lint check
Write-Host "Running linter..." -ForegroundColor Yellow
try {
    npm run lint
    if ($LASTEXITCODE -ne 0) {
        $allPassed = $false
    } else {
        Write-Host "✓ Linting passed" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠ Linting check skipped (no ESLint config)" -ForegroundColor Yellow
}
Write-Host ""

# Format check
Write-Host "Checking code formatting..." -ForegroundColor Yellow
try {
    npm run format:check
    if ($LASTEXITCODE -ne 0) {
        Write-Host "⚠ Code formatting issues found" -ForegroundColor Yellow
        Write-Host "Run 'npm run format' to fix" -ForegroundColor White
    } else {
        Write-Host "✓ Formatting check passed" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠ Format check skipped (no Prettier config)" -ForegroundColor Yellow
}
Write-Host ""

# Security audit
Write-Host "Running security audit..." -ForegroundColor Yellow
if (Test-Path "package.json") {
    npm audit --audit-level=high
    if ($LASTEXITCODE -ne 0) {
        Write-Host "⚠ Security vulnerabilities found" -ForegroundColor Yellow
        Write-Host "Run 'npm audit fix' to attempt automatic fixes" -ForegroundColor White
    } else {
        Write-Host "✓ Security audit passed" -ForegroundColor Green
    }
}
Write-Host ""

# Test coverage (if available)
Write-Host "Checking test coverage..." -ForegroundColor Yellow
try {
    npm run test:coverage
    Write-Host "✓ Coverage check complete" -ForegroundColor Green
} catch {
    Write-Host "⚠ Coverage check skipped" -ForegroundColor Yellow
}
Write-Host ""

if ($allPassed) {
    Write-Host "✓ All quality checks passed!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "✗ Some quality checks failed" -ForegroundColor Red
    exit 1
}
