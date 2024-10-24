#!/bin/bash

# monitoring.sh (modified for GitHub Actions)

# Directory containing Terraform modules inside the container
MODULES_DIR="/usr/src/app/gcp/modules"

# Function to handle MkDocs serve, assuming it is invoked locally or within a CI/CD environment
start_mkdocs_serve() {
    # Start MkDocs serve (typically this part is run locally, not in CI/CD)
    echo "Serving MkDocs on port 8080 (not applicable in CI/CD)."
}

# First, generate documentation for all modules
for dir in "$MODULES_DIR"/*/; do
    if [ -d "$dir" ]; then
        ./scripts/generate.sh "$dir"
        echo "Documentation generated for module: $dir"
    fi
done


