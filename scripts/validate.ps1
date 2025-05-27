# Pre-commit validation script for homelab GitOps repository
# Validates that Windsurf rules are followed before committing

Write-Host "Running pre-commit validation for homelab GitOps repository..." -ForegroundColor Cyan

# Check if windsurf CLI is installed
$windsurfExists = Get-Command windsurf -ErrorAction SilentlyContinue

if (-not $windsurfExists) {
    Write-Host "Error: windsurf CLI is not installed. Please install it first." -ForegroundColor Red
    Write-Host "Visit: https://github.com/windsurftech/windsurf-cli" -ForegroundColor Yellow
    exit 1
}

# Run validation
Write-Host "Validating repository against Windsurf rules..." -ForegroundColor Cyan
windsurf validate --config windsurf.yaml

# Check result
if ($LASTEXITCODE -ne 0) {
    Write-Host "Validation failed. Please fix the issues before committing." -ForegroundColor Red
    exit 1
} else {
    Write-Host "Validation passed. Proceeding with commit." -ForegroundColor Green
}

exit 0
