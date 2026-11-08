#!/bin/bash
# Local Azure Pipeline Simulation for Unit Testing Sample
# This script runs all the steps from azure-pipelines.yml locally

set -e  # Exit on error

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log_step() {
    echo -e "${YELLOW}▶ $1${NC}"
}

log_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

log_error() {
    echo -e "${RED}✗ $1${NC}"
}

echo -e "${CYAN}========================================"
echo -e "  Local Pipeline Simulation"
echo -e "========================================${NC}"
echo ""

# Check .NET SDK
log_step "Checking .NET SDK..."
if ! command -v dotnet &> /dev/null; then
    log_error "dotnet CLI not found. Please install .NET 10 SDK from https://dotnet.microsoft.com/en-us/download/dotnet/10.0"
    exit 1
fi
dotnet_version=$(dotnet --version)
log_success ".NET SDK Version: $dotnet_version"
echo ""

# Step 1: Restore Dependencies
log_step "Restore Dependencies..."
dotnet restore
log_success "Dependencies restored"
echo ""

# Step 2: Build
log_step "Build Solution..."
dotnet build --configuration Release
log_success "Build succeeded"
echo ""

# Step 3: Unit Tests
log_step "Running Unit Tests..."
if [ "$1" = "-v" ] || [ "$1" = "--verbose" ]; then
    dotnet test --no-build --configuration Release --verbosity detailed --logger "console;verbosity=detailed"
else
    dotnet test --no-build --configuration Release
fi
log_success "All tests passed"
echo ""

echo -e "${CYAN}========================================"
echo -e "  Pipeline completed successfully!"
echo -e "========================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  - Check bin/Debug or bin/Release for built assemblies"
echo "  - Review test results above"
echo "  - Run with -v flag for detailed output"
