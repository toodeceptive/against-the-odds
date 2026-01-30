# Launch Chrome with remote debugging so the agent/Playwright can connect to your browser.
# Use this when you want get-access-token.ps1 or other browser automation to use YOUR Chrome.
# Close Chrome first, then run this script; log in to Shopify (or the service) in the opened window.

$ErrorActionPreference = "Stop"
$chromePaths = @(
    "C:\Program Files\Google\Chrome\Application\chrome.exe",
    "${env:LOCALAPPDATA}\Google\Chrome\Application\chrome.exe"
)
$chrome = $null
foreach ($p in $chromePaths) {
    if (Test-Path $p) { $chrome = $p; break }
}
if (-not $chrome) {
    Write-Host "Chrome not found. Install Chrome or set path in this script." -ForegroundColor Red
    exit 1
}

$url = "https://aodrop.com/admin"
Write-Host "Launching Chrome with remote debugging (port 9222)..." -ForegroundColor Cyan
Write-Host "After Chrome opens, log in to Shopify. Then run: .\scripts\shopify\browser\get-access-token.ps1" -ForegroundColor Yellow
Start-Process -FilePath $chrome -ArgumentList "--remote-debugging-port=9222", $url
