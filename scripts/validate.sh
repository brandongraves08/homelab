#!/bin/bash

# Pre-commit validation script for homelab GitOps repository
# Validates that Windsurf rules are followed before committing

echo "Running pre-commit validation for homelab GitOps repository..."

# Check if windsurf CLI is installed
if ! command -v windsurf &> /dev/null; then
    echo "Error: windsurf CLI is not installed. Please install it first."
    echo "Visit: https://github.com/windsurftech/windsurf-cli"
    exit 1
fi

# Run validation
echo "Validating repository against Windsurf rules..."
windsurf validate --config windsurf.yaml

# Check result
if [ $? -ne 0 ]; then
    echo "Validation failed. Please fix the issues before committing."
    exit 1
else
    echo "Validation passed. Proceeding with commit."
fi

exit 0
