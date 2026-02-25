# Open pending-approval.md and the theme preview in the browser so the user sees both on their desktop.
# Run from repo root. Starts theme dev in a new window, then opens browser + approval file after a delay.
# Uses cmd /c start and full paths so the browser actually opens when run from Cursor/IDE terminals.

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
    (Get-Location).Path
}

$pendingFile = Join-Path $repoPath "docs/status/pending-approval.md"
$themeDevScript = Join-Path $repoPath "scripts/shopify/theme-dev.ps1"
$previewUrl = "http://127.0.0.1:9292"

# Find a real browser exe (Chrome, Edge, Firefox) so .html opens in browser, not in VS Code/Cursor
function Get-BrowserExe {
    $candidates = @(
        "C:\Program Files\Google\Chrome\Application\chrome.exe",
        "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
        "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe",
        "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
        "C:\Program Files\Microsoft\Edge\Application\msedge.exe",
        "C:\Program Files\Mozilla Firefox\firefox.exe",
        "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
    )
    foreach ($exe in $candidates) {
        if ($exe -and (Test-Path -LiteralPath $exe -ErrorAction SilentlyContinue)) {
            return $exe
        }
    }
    # Last resort: registry default for http (might still be IDE in rare cases)
    try {
        $progId = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice' -ErrorAction SilentlyContinue).ProgId
        if ($progId) {
            $cmd = (Get-ItemProperty -Path "HKCR:\$progId\shell\open\command" -ErrorAction SilentlyContinue).'(default)'
            if ($cmd -match '^"([^"]+)"') { $exe = $matches[1]; if (Test-Path -LiteralPath $exe -ErrorAction SilentlyContinue) { return $exe } }
            if ($cmd -match '^([^\s"]+)') { $exe = $matches[1]; if (Test-Path -LiteralPath $exe -ErrorAction SilentlyContinue) { return $exe } }
        }
    } catch { }
    return $null
}

# Open a URL or file in a real browser (Chrome/Edge/Firefox), not in VS Code/Cursor
function Open-InBrowser {
    param([string]$UrlOrPath)
    $isFile = $UrlOrPath -match '^[A-Za-z]:\\'
    $target = $UrlOrPath
    if ($isFile) {
        $target = (Resolve-Path -LiteralPath $UrlOrPath -ErrorAction SilentlyContinue).Path
        if (-not $target) { $target = $UrlOrPath }
    }
    # 1) Use Chrome/Edge/Firefox by path so .html never goes to VS Code
    $browserExe = Get-BrowserExe
    if ($browserExe) {
        try {
            Start-Process -FilePath $browserExe -ArgumentList $target
            return
        } catch { }
    }
    # 2) For http only: Start-Process with URL
    if (-not $isFile) {
        try { Start-Process $target; return } catch { }
    }
    # 3) Fallback (may open in VS Code if .html is associated)
    try {
        $quoted = "`"$target`""
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "start", "", $quoted -WorkingDirectory $repoPath
    } catch { }
}

# 1) Open pending approval in Cursor (or VS Code) so it opens in your editor instead of "Open with" picker
if (Test-Path $pendingFile) {
    if (Get-Command cursor -ErrorAction SilentlyContinue) {
        cursor -r $pendingFile
        Write-Host "Opened pending-approval.md in Cursor" -ForegroundColor Cyan
    } elseif (Get-Command code -ErrorAction SilentlyContinue) {
        code -r $pendingFile
        Write-Host "Opened pending-approval.md in VS Code" -ForegroundColor Cyan
    } else {
        Invoke-Item $pendingFile
        Write-Host "Opened pending-approval.md (default app)" -ForegroundColor Cyan
    }
} else {
    Write-Host "Pending approval file not found: $pendingFile" -ForegroundColor Yellow
}

# 2) Open static preview in browser immediately so something always appears
$mockPath = Join-Path $repoPath "docs/guides/theme-preview-mock.html"
if (Test-Path $mockPath) {
    Open-InBrowser $mockPath
    Write-Host "Opened AO preview (static mock) in your browser." -ForegroundColor Cyan
}

# 3) Start theme dev server in a new window
if (Test-Path $themeDevScript) {
    Start-Process powershell -ArgumentList @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", $themeDevScript
    ) -WorkingDirectory $repoPath
    Write-Host "Theme dev server starting in a new window..." -ForegroundColor Cyan
} else {
    Write-Host "Theme dev script not found: $themeDevScript" -ForegroundColor Red
}

# 4) Wait for theme dev server to respond, then open live URL if ready
$maxWaitSeconds = if ($env:PREVIEW_POPUP_MAX_WAIT_SECONDS -match '^\d+$') { [int]$env:PREVIEW_POPUP_MAX_WAIT_SECONDS } else { 90 }
$intervalSeconds = 2
$elapsed = 0
Write-Host "Waiting for theme dev server (up to ${maxWaitSeconds}s)..." -ForegroundColor Cyan
$serverReady = $false
while ($elapsed -lt $maxWaitSeconds) {
    try {
        $null = Invoke-WebRequest -Uri $previewUrl -TimeoutSec 2 -UseBasicParsing -ErrorAction SilentlyContinue
        $serverReady = $true
        Write-Host "Server is ready after ${elapsed}s." -ForegroundColor Green
        break
    } catch { }
    Start-Sleep -Seconds $intervalSeconds
    $elapsed += $intervalSeconds
    Write-Host "  ... ${elapsed}s" -ForegroundColor Gray
}
if ($serverReady) {
    Open-InBrowser $previewUrl
    Write-Host "Browser opened to $previewUrl" -ForegroundColor Green
} else {
    Write-Host "Theme dev did not respond in time." -ForegroundColor Yellow
    Write-Host "Check the OTHER PowerShell window that opened: if it says 'log in to Shopify', open the link, complete login, then run this script again for live preview." -ForegroundColor Yellow
    $mockPath = Join-Path $repoPath "docs/guides/theme-preview-mock.html"
    if (Test-Path $mockPath) {
        Open-InBrowser $mockPath
        Write-Host "Opened static preview fallback (AO style mock) in your browser." -ForegroundColor Cyan
    } else {
        Open-InBrowser $previewUrl
        Write-Host "Browser opened to $previewUrl - refresh after theme dev is running." -ForegroundColor Gray
    }
}
