#!/bin/bash

# monitoring.sh (modified for GitHub Actions)

# Directory containing Terraform modules inside the container
MODULES_DIR="/usr/src/app/gcp/modules"

# Function to handle MkDocs serve, assuming it is invoked locally or within a CI/CD environment
start_mkdocs_serve() {
    echo "Serving MkDocs on port 8080 (not applicable in CI/CD)."
    mkdocs serve --dev-addr=0.0.0.0:8080
}

# Check if the MODULES_DIR exists
if [ ! -d "$MODULES_DIR" ]; then
    echo "Error: Modules directory $MODULES_DIR does not exist."
    exit 1
fi

# Check if there are any subdirectories in MODULES_DIR
if [ -z "$(ls -A "$MODULES_DIR")" ]; then
    echo "Warning: No modules found in $MODULES_DIR."
    exit 0
fi

# First, generate documentation for all modules
for dir in "$MODULES_DIR"/*/; do
    if [ -d "$dir" ]; then
        echo "Generating documentation for module: $dir"
        
        # Call the generate script and check for errors
        ./scripts/generate.sh "$dir"
        if [ $? -ne 0 ]; then
            echo "Error: Documentation generation failed for module $dir"
            exit 1
        fi
        
        echo "Documentation successfully generated for module: $dir"
    else
        echo "Warning: $dir is not a valid directory."
    fi
done

# Optionally start MkDocs serve if running locally, skip if in CI/CD
if [ -z "$CI" ]; then
    start_mkdocs_serve
else
    echo "Skipping MkDocs serve in CI/CD environment."
fi




