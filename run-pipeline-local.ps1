# Local Azure Pipeline Simulation for Unit Testing Sample
# This script runs all the steps from azure-pipelines.yml locally

param(
    [switch]$Verbose = $false
)

Write-Host '========================================' -ForegroundColor Cyan
Write-Host '  Local Pipeline Simulation' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''

# Color helpers
$ErrorColor = 'Red'
$SuccessColor = 'Green'
$InfoColor = 'Yellow'

function Log-Step {
    param([string]$Message)
    Write-Host "▶ $Message" -ForegroundColor $InfoColor
}

function Log-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor $SuccessColor
}

function Log-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor $ErrorColor
}

# Check .NET SDK
Log-Step 'Checking .NET SDK...'
$dotnetVersion = & dotnet --version
if ($LASTEXITCODE -ne 0) {
    Log-Error 'dotnet CLI not found. Please install .NET 10 SDK from https://dotnet.microsoft.com/en-us/download/dotnet/10.0'
    exit 1
}
Log-Success ".NET SDK Version: $dotnetVersion"
Write-Host ''

# Step 1: Restore Dependencies
Log-Step 'Restore Dependencies...'
& dotnet restore
if ($LASTEXITCODE -ne 0) {
    Log-Error 'Restore failed'
    exit 1
}
Log-Success 'Dependencies restored'
Write-Host ''

# Step 2: Build
Log-Step 'Build Solution...'
& dotnet build --configuration Release
if ($LASTEXITCODE -ne 0) {
    Log-Error 'Build failed'
    exit 1
}
Log-Success 'Build succeeded'
Write-Host ''

# Step 3: Unit Tests
Log-Step 'Running Unit Tests...'
if ($Verbose) {
    & dotnet test --no-build --configuration Release --verbosity detailed --logger 'console;verbosity=detailed'
}
else {
    & dotnet test --no-build --configuration Release
}
if ($LASTEXITCODE -ne 0) {
    Log-Error 'Tests failed'
    exit 1
}
Log-Success 'All tests passed'
Write-Host ''

Write-Host '========================================' -ForegroundColor Cyan
Write-Host '  Pipeline completed successfully!' -ForegroundColor $SuccessColor
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''
Write-Host 'Next steps:' -ForegroundColor $InfoColor
Write-Host '  - Check bin/Debug or bin/Release for built assemblies'
Write-Host '  - Review test results above'
Write-Host '  - Run with -Verbose flag for detailed output'
