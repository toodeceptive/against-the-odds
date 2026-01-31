# Shared PowerShell Utilities
# Common functions for all scripts to reduce duplication

#region Error Handling

function Write-ErrorWithContext {
    param(
        [string]$Message,
        [Exception]$Exception = $null,
        [string]$ScriptName = $MyInvocation.ScriptName
    )
    
    Write-Host "[FAIL] Error in $ScriptName" -ForegroundColor Red
    Write-Host "  $Message" -ForegroundColor Red
    if ($Exception) {
        Write-Host "  Details: $($Exception.Message)" -ForegroundColor Red
        if ($Exception.ErrorDetails.Message) {
            try {
                $errorDetails = $Exception.ErrorDetails.Message | ConvertFrom-Json
                if ($errorDetails.errors) {
                    $errorMessages = $errorDetails.errors | ForEach-Object {
                        if ($_.message) { $_.message } else { $_ }
                    }
                    Write-Host "  API Errors: $($errorMessages -join '; ')" -ForegroundColor Red
                }
            } catch {
                # Ignore JSON parsing errors
            }
        }
    }
}

function Test-Command {
    param([string]$CommandName)
    
    $null = Get-Command $CommandName -ErrorAction SilentlyContinue
    return $?
}

#endregion

#region Environment

function Get-EnvVar {
    param(
        [string]$Name,
        [string]$DefaultValue = $null
    )
    
    $value = [System.Environment]::GetEnvironmentVariable($Name, 'Process')
    if ([string]::IsNullOrWhiteSpace($value)) {
        $value = [System.Environment]::GetEnvironmentVariable($Name, 'User')
    }
    if ([string]::IsNullOrWhiteSpace($value) -and (Test-Path ".env.local")) {
        $envContent = Get-Content ".env.local"
        foreach ($line in $envContent) {
            if ($line -match "^$Name=(.+)$" -and -not $line.StartsWith('#')) {
                $value = $matches[1].Trim()
                break
            }
        }
    }
    
    if ([string]::IsNullOrWhiteSpace($value)) {
        $value = $DefaultValue
    }
    
    return $value
}

function Set-RepoLocation {
    param([string]$RepoPath = $null)
    
    if ([string]::IsNullOrWhiteSpace($RepoPath)) {
        # Derive repo root from this script's location (scripts/shared -> repo root)
        $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
        if ($scriptDir) {
            $parent = Join-Path $scriptDir ".."
            $grandParent = Join-Path $parent ".."
            $RepoPath = (Resolve-Path $grandParent).Path
        } else {
            $RepoPath = (Get-Location).Path
        }
    }
    
    if (Test-Path $RepoPath) {
        Set-Location $RepoPath
        return $true
    } else {
        Write-Host "Error: Repository path not found: $RepoPath" -ForegroundColor Red
        return $false
    }
}

#endregion

#region API Helpers

function Invoke-ShopifyAPI {
    param(
        [string]$Store,
        [string]$Token,
        [string]$Endpoint,
        [string]$Method = "Get",
        [object]$Body = $null,
        [hashtable]$Headers = $null
    )
    
    $baseUrl = "https://$Store/admin/api/2026-01"
    $url = "$baseUrl/$Endpoint"
    
    $requestHeaders = @{
        "X-Shopify-Access-Token" = $Token
        "Content-Type" = "application/json"
    }
    
    if ($Headers) {
        foreach ($key in $Headers.Keys) {
            $requestHeaders[$key] = $Headers[$key]
        }
    }
    
    $params = @{
        Uri = $url
        Headers = $requestHeaders
        Method = $Method
        TimeoutSec = 30
    }
    
    if ($Body) {
        if ($Body -is [string]) {
            $params.Body = $Body
        } else {
            $params.Body = $Body | ConvertTo-Json -Depth 10
        }
    }
    
    try {
        return Invoke-RestMethod @params
    } catch {
        Write-ErrorWithContext -Message "Shopify API call failed: $Endpoint" -Exception $_
        throw
    }
}

function Invoke-GitHubAPI {
    param(
        [string]$Token,
        [string]$Endpoint,
        [string]$Method = "Get",
        [object]$Body = $null
    )
    
    $url = "https://api.github.com/$Endpoint"
    
    $headers = @{
        "Authorization" = "token $Token"
        "Accept" = "application/vnd.github.v3+json"
    }
    
    $params = @{
        Uri = $url
        Headers = $headers
        Method = $Method
        TimeoutSec = 30
    }
    
    if ($Body) {
        if ($Body -is [string]) {
            $params.Body = $Body
        } else {
            $params.Body = $Body | ConvertTo-Json -Depth 10
        }
    }
    
    try {
        return Invoke-RestMethod @params
    } catch {
        Write-ErrorWithContext -Message "GitHub API call failed: $Endpoint" -Exception $_
        throw
    }
}

#endregion

#region Progress Indicators

function Write-ProgressStep {
    param(
        [int]$Step,
        [int]$Total,
        [string]$Message
    )
    
    $percent = [math]::Round(($Step / $Total) * 100)
    Write-Host "[$Step/$Total] $Message" -ForegroundColor Cyan
    Write-Progress -Activity "Processing" -Status $Message -PercentComplete $percent
}

function Write-Success {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

#endregion

#region Retry Logic

function Invoke-WithRetry {
    param(
        [scriptblock]$ScriptBlock,
        [int]$MaxRetries = 3,
        [int]$DelaySeconds = 2,
        [string]$ErrorMessage = "Operation failed after retries"
    )
    
    $attempt = 0
    $lastError = $null
    
    while ($attempt -lt $MaxRetries) {
        $attempt++
        try {
            return & $ScriptBlock
        } catch {
            $lastError = $_
            if ($attempt -lt $MaxRetries) {
                Write-Warning "Attempt $attempt failed, retrying in $DelaySeconds seconds..."
                Start-Sleep -Seconds $DelaySeconds
                $DelaySeconds = $DelaySeconds * 2  # Exponential backoff
            }
        }
    }
    
    Write-ErrorWithContext -Message $ErrorMessage -Exception $lastError
    throw $lastError
}

#endregion

#region Validation

function Test-ShopifyCredentials {
    param(
        [string]$Store,
        [string]$Token
    )
    
    if ([string]::IsNullOrWhiteSpace($Store) -or [string]::IsNullOrWhiteSpace($Token)) {
        return $false
    }
    
    try {
        $result = Invoke-ShopifyAPI -Store $Store -Token $Token -Endpoint "shop.json"
        return $true
    } catch {
        return $false
    }
}

function Test-GitHubCredentials {
    param([string]$Token)
    
    if ([string]::IsNullOrWhiteSpace($Token)) {
        return $false
    }
    
    try {
        $result = Invoke-GitHubAPI -Token $Token -Endpoint "user"
        return $true
    } catch {
        return $false
    }
}

#endregion

# Export functions
Export-ModuleMember -Function @(
    'Write-ErrorWithContext',
    'Test-Command',
    'Get-EnvVar',
    'Set-RepoLocation',
    'Invoke-ShopifyAPI',
    'Invoke-GitHubAPI',
    'Write-ProgressStep',
    'Write-Success',
    'Write-Warning',
    'Write-Info',
    'Invoke-WithRetry',
    'Test-ShopifyCredentials',
    'Test-GitHubCredentials'
)
