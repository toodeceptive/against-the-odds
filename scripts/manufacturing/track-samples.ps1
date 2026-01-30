# Track manufacturing samples - requests, deliveries, and evaluations

param(
    [ValidateSet("add", "list", "update", "evaluate")]
    [string]$Action = "list",
    [string]$Manufacturer = "",
    [string]$SampleId = "",
    [string]$Status = "",
    [string]$ProductType = "Hoodie",
    [string]$ExpectedDelivery = "",
    [string]$TrackingNumber = "",
    [string]$Notes = "",
    [hashtable]$Evaluation = $null
)

$ErrorActionPreference = "Stop"
$repoPath = "C:\Users\LegiT\against-the-odds"
Set-Location $repoPath

$samplesDir = "data\samples"
$samplesFile = "$samplesDir\samples.json"

# Ensure samples directory exists
if (-not (Test-Path $samplesDir)) {
    New-Item -ItemType Directory -Force -Path $samplesDir | Out-Null
}

# Load existing samples
$samples = @()
if (Test-Path $samplesFile) {
    try {
        $jsonContent = Get-Content $samplesFile -Raw
        if (-not [string]::IsNullOrWhiteSpace($jsonContent)) {
            $samples = $jsonContent | ConvertFrom-Json
            # Ensure it's an array
            if ($samples -isnot [Array]) {
                $samples = @($samples)
            }
        }
    } catch {
        Write-Host "Warning: Could not load samples file. Starting fresh." -ForegroundColor Yellow
        $samples = @()
    }
}

function Save-Samples {
    $samples | ConvertTo-Json -Depth 10 | Out-File -FilePath $samplesFile -Encoding UTF8
}

function Add-Sample {
    param([hashtable]$SampleData)
    
    $sample = @{
        id = [System.Guid]::NewGuid().ToString()
        manufacturer = $SampleData.manufacturer
        product_type = $SampleData.product_type
        requested_date = (Get-Date).ToString("yyyy-MM-dd")
        expected_delivery = $SampleData.expected_delivery
        status = "requested"
        tracking_number = $SampleData.tracking_number
        notes = $SampleData.notes
        evaluation = $null
    }
    
    $script:samples += $sample
    Save-Samples
    Write-Host "[OK] Added sample: $($sample.id)" -ForegroundColor Green
    return $sample
}

function List-Samples {
    if ($samples.Count -eq 0) {
        Write-Host "No samples tracked yet." -ForegroundColor Yellow
        return
    }
    
    Write-Host "=== Tracked Samples ===" -ForegroundColor Cyan
    Write-Host ""
    
    foreach ($sample in $samples) {
        Write-Host "ID: $($sample.id)" -ForegroundColor Yellow
        Write-Host "  Manufacturer: $($sample.manufacturer)"
        Write-Host "  Product Type: $($sample.product_type)"
        Write-Host "  Status: $($sample.status)"
        Write-Host "  Requested: $($sample.requested_date)"
        if ($sample.expected_delivery) {
            Write-Host "  Expected Delivery: $($sample.expected_delivery)"
        }
        if ($sample.tracking_number) {
            Write-Host "  Tracking: $($sample.tracking_number)"
        }
        if ($sample.evaluation) {
            Write-Host "  Evaluation: $($sample.evaluation.rating)/10"
            Write-Host "    Notes: $($sample.evaluation.notes)"
        }
        Write-Host ""
    }
}

function Update-Sample {
    param([string]$Id, [string]$Status, [string]$TrackingNumber)
    
    $sample = $samples | Where-Object { $_.id -eq $Id }
    if (-not $sample) {
        Write-Host "Sample not found: $Id" -ForegroundColor Red
        return
    }
    
    if ($Status) {
        $sample.status = $Status
    }
    if ($TrackingNumber) {
        $sample.tracking_number = $TrackingNumber
    }
    
    if ($Status -eq "delivered") {
        $sample.delivered_date = (Get-Date).ToString("yyyy-MM-dd")
    }
    
    Save-Samples
    Write-Host "[OK] Updated sample: $Id" -ForegroundColor Green
}

function Evaluate-Sample {
    param([string]$Id, [hashtable]$Evaluation)
    
    $sample = $samples | Where-Object { $_.id -eq $Id }
    if (-not $sample) {
        Write-Host "Sample not found: $Id" -ForegroundColor Red
        return
    }
    
    $sample.evaluation = @{
        rating = $Evaluation.rating
        notes = $Evaluation.notes
        quality_score = $Evaluation.quality_score
        price_score = $Evaluation.price_score
        delivery_score = $Evaluation.delivery_score
        recommended = $Evaluation.recommended
        evaluated_date = (Get-Date).ToString("yyyy-MM-dd")
    }
    
    Save-Samples
    Write-Host "[OK] Evaluated sample: $Id" -ForegroundColor Green
}

# Execute action
switch ($Action) {
    "add" {
        if ([string]::IsNullOrWhiteSpace($Manufacturer)) {
            Write-Host "Error: Manufacturer name required" -ForegroundColor Red
            Write-Host "Usage: .\track-samples.ps1 -Action add -Manufacturer 'Company Name' -ProductType 'Hoodie'"
            exit 1
        }
        
        $sampleData = @{
            manufacturer = $Manufacturer
            product_type = $ProductType
            expected_delivery = if ([string]::IsNullOrWhiteSpace($ExpectedDelivery)) { $null } else { $ExpectedDelivery }
            tracking_number = if ([string]::IsNullOrWhiteSpace($TrackingNumber)) { $null } else { $TrackingNumber }
            notes = $Notes
        }
        
        Add-Sample -SampleData $sampleData
    }
    "list" {
        List-Samples
    }
    "update" {
        if ([string]::IsNullOrWhiteSpace($SampleId)) {
            Write-Host "Error: Sample ID required" -ForegroundColor Red
            exit 1
        }
        Update-Sample -Id $SampleId -Status $Status -TrackingNumber $PSBoundParameters['TrackingNumber']
    }
    "evaluate" {
        if ([string]::IsNullOrWhiteSpace($SampleId)) {
            Write-Host "Error: Sample ID required" -ForegroundColor Red
            exit 1
        }
        if (-not $Evaluation) {
            Write-Host "Error: Evaluation data required" -ForegroundColor Red
            exit 1
        }
        Evaluate-Sample -Id $SampleId -Evaluation $Evaluation
    }
}
