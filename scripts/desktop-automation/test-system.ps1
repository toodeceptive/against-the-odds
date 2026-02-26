# Desktop Automation System Test Script
param([switch]$Quick)

Write-Host "=== Desktop Automation System Test ===" -ForegroundColor Cyan
Write-Host ""

# Test Node.js
Write-Host "Testing Node.js..." -ForegroundColor Yellow
$nodeVersion = node --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  OK Node.js version: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "  FAIL Node.js not found" -ForegroundColor Red
    exit 1
}

# Test npm
Write-Host "Testing npm..." -ForegroundColor Yellow
$npmVersion = npm --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  OK npm version: $npmVersion" -ForegroundColor Green
} else {
    Write-Host "  FAIL npm not found" -ForegroundColor Red
    exit 1
}

# Test dependencies
Write-Host "Testing dependencies..." -ForegroundColor Yellow
$deps = @("screenshot-desktop", "tesseract.js", "sharp", "robotjs", "node-window-manager")
$missing = @()
foreach ($dep in $deps) {
    npm list $dep --depth=0 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  OK $dep installed" -ForegroundColor Green
    } else {
        Write-Host "  FAIL $dep not installed" -ForegroundColor Red
        $missing += $dep
    }
}
if ($missing.Count -gt 0) {
    Write-Host "Missing dependencies. Run: npm install" -ForegroundColor Yellow
}

# Test files
Write-Host "Testing file structure..." -ForegroundColor Yellow
$files = @(
    "src/desktop-automation/screen-capture.js",
    "src/desktop-automation/mouse-control.js",
    "src/desktop-automation/keyboard-control.js",
    "src/desktop-automation/window-manager.js",
    "src/desktop-automation/orchestrator.js",
    "prompts/head-guru-orchestrator.md"
)
$missingFiles = @()
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "  OK $file exists" -ForegroundColor Green
    } else {
        Write-Host "  FAIL $file missing" -ForegroundColor Red
        $missingFiles += $file
    }
}
if ($missingFiles.Count -gt 0) {
    Write-Host "Missing files detected!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== Test Complete ===" -ForegroundColor Cyan
if ($missing.Count -eq 0 -and $missingFiles.Count -eq 0) {
    Write-Host "System is ready!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "System needs attention" -ForegroundColor Yellow
    exit 1
}
