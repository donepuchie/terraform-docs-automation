#!/bin/bash

# monitoring.sh (for use within a container)

# Directory containing Terraform modules inside the container
MODULES_DIR="/usr/src/app/gcp/modules"

# Function to trigger the batch generation process
trigger_doc_generation() {
    if [ -d "$MODULES_DIR" ]; then
        echo "Starting documentation generation for all modules in $MODULES_DIR"
        
        # Call generate.sh to process all modules in batch
        ./scripts/generate.sh "$MODULES_DIR"
        
        if [ $? -ne 0 ]; then
            echo "Error: Documentation generation failed."
            exit 1
        else
            echo "Documentation generation for all modules completed successfully."
        fi
    else
        echo "Error: Modules directory $MODULES_DIR does not exist."
        exit 1
    fi
}

# Monitor the modules directory and trigger generation
trigger_doc_generation




