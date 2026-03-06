# Open pending-approval.md and the theme preview in the browser so the user sees both on their desktop.
# Run from repo root. Starts theme dev in a new window when the platform supports it and
# otherwise degrades cleanly so non-Windows environments can still open the approval file/preview.

$ErrorActionPreference = "Stop"
$repoPath = if ($PSScriptRoot) {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
    (Get-Location).Path
}

$pendingFile = Join-Path $repoPath "docs/status/pending-approval.md"
$themeDevScript = Join-Path $repoPath "scripts/shopify/theme-dev.ps1"
$previewUrl = "http://127.0.0.1:9292"
$isWindowsPlatform = $env:OS -eq "Windows_NT"
$isMacOSPlatform = $false
if (-not $isWindowsPlatform -and (Get-Command uname -ErrorAction SilentlyContinue)) {
    $isMacOSPlatform = (uname) -eq "Darwin"
}

function Get-BrowserExe {
    if (-not $isWindowsPlatform) {
        return $null
    }

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

function Get-PowerShellCommand {
    foreach ($candidate in @("pwsh", "powershell")) {
        if (Get-Command $candidate -ErrorAction SilentlyContinue) {
            return $candidate
        }
    }

    return $null
}

function Open-DefaultTarget {
    param([string]$Target)

    if ($isWindowsPlatform) {
        Start-Process $Target
        return $true
    }

    $openCommand = if ($isMacOSPlatform) { "open" } else { "xdg-open" }
    if (Get-Command $openCommand -ErrorAction SilentlyContinue) {
        & $openCommand $Target | Out-Null
        return $LASTEXITCODE -eq 0
    }

    return $false
}

function Open-InBrowser {
    param([string]$UrlOrPath)

    $isUrl = $UrlOrPath -match '^[a-z]+://'
    $target = $UrlOrPath
    if (-not $isUrl) {
        $resolved = Resolve-Path -LiteralPath $UrlOrPath -ErrorAction SilentlyContinue
        if ($resolved) {
            $target = $resolved.Path
        }
    }

    $browserExe = Get-BrowserExe
    if ($browserExe) {
        try {
            Start-Process -FilePath $browserExe -ArgumentList $target
            return
        } catch { }
    }

    try {
        if (Open-DefaultTarget $target) {
            return
        }
    } catch { }

    if ($isWindowsPlatform) {
        try {
            $quoted = "`"$target`""
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "start", "", $quoted -WorkingDirectory $repoPath
            return
        } catch { }
    }

    Write-Host "Could not auto-open $target on this machine. Open it manually if needed." -ForegroundColor Yellow
}

function Start-ThemeDevWindow {
    param([string]$ScriptPath)

    $powerShellCommand = Get-PowerShellCommand
    if (-not $powerShellCommand) {
        Write-Host "No PowerShell executable found; start theme dev manually." -ForegroundColor Yellow
        return $false
    }

    $psArgs = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $ScriptPath)

    if ($isWindowsPlatform) {
        Start-Process -FilePath $powerShellCommand -ArgumentList $psArgs -WorkingDirectory $repoPath
        return $true
    }

    $terminalCandidates = @(
        @{ Command = "x-terminal-emulator"; Args = @("-e", $powerShellCommand) + $psArgs },
        @{ Command = "gnome-terminal"; Args = @("--", $powerShellCommand) + $psArgs },
        @{ Command = "konsole"; Args = @("-e", $powerShellCommand) + $psArgs },
        @{ Command = "xterm"; Args = @("-e", $powerShellCommand) + $psArgs }
    )

    foreach ($candidate in $terminalCandidates) {
        if (Get-Command $candidate.Command -ErrorAction SilentlyContinue) {
            try {
                Start-Process -FilePath $candidate.Command -ArgumentList $candidate.Args -WorkingDirectory $repoPath
                return $true
            } catch { }
        }
    }

    Write-Host "No desktop terminal launcher found. Start 'Shopify: Theme Dev' separately for live preview." -ForegroundColor Yellow
    return $false
}

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

$mockPath = Join-Path $repoPath "docs/guides/theme-preview-mock.html"
if (Test-Path $mockPath) {
    Open-InBrowser $mockPath
    Write-Host "Opened AO preview (static mock) in your browser." -ForegroundColor Cyan
}

$themeDevStarted = $false
if (Test-Path $themeDevScript) {
    $themeDevStarted = Start-ThemeDevWindow -ScriptPath $themeDevScript
    if ($themeDevStarted) {
        Write-Host "Theme dev server starting in a new window..." -ForegroundColor Cyan
    } else {
        Write-Host "Theme dev was not auto-started in a separate window on this platform." -ForegroundColor Yellow
    }
} else {
    Write-Host "Theme dev script not found: $themeDevScript" -ForegroundColor Red
}

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
    if ($themeDevStarted) {
        Write-Host "Check the other PowerShell or terminal window. If it says 'log in to Shopify', complete login and run this script again for live preview." -ForegroundColor Yellow
    } else {
        Write-Host "Run 'Shopify: Theme Dev' manually, then refresh the preview URL once the server is ready." -ForegroundColor Yellow
    }
    if (Test-Path $mockPath) {
        Open-InBrowser $mockPath
        Write-Host "Opened static preview fallback (AO style mock) in your browser." -ForegroundColor Cyan
    } else {
        Open-InBrowser $previewUrl
        Write-Host "Browser opened to $previewUrl - refresh after theme dev is running." -ForegroundColor Gray
    }
}
