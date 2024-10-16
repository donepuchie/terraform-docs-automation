#!/bin/bash

# monitoring.sh
# Directory containing Terraform modules inside the container
MODULES_DIR="/usr/src/app/gcp/modules"
FIRST_RUN_FLAG="/tmp/first_run_complete"
MKDOCS_RUNNING_FLAG="/tmp/mkdocs_running"

# Function to handle mkdocs serve, ensuring no duplicate servers are running
start_mkdocs_serve() {
    if [ -f "$MKDOCS_RUNNING_FLAG" ]; then
        # Kill any existing mkdocs serve process
        pkill -f "mkdocs serve"
        echo "Previous MkDocs process killed."
    fi
    # Start MkDocs serve and write to the running flag
    mkdocs serve --dev-addr=0.0.0.0:8080 &
    echo "Serving MkDocs on port 8080."
    touch "$MKDOCS_RUNNING_FLAG"
}

# First, generate documentation for all modules
for dir in "$MODULES_DIR"/*/; do
    if [ -d "$dir" ]; then
        ./scripts/generate.sh "$dir"
    fi
done

# Flag to indicate that the first generation run has been completed
touch $FIRST_RUN_FLAG

# Now, monitor changes in .tf files inside the modules directory recursively
inotifywait -m -r -e modify,create,delete --format '%w%f' "$MODULES_DIR" |
while read FILE
do
    # Only react to changes in .tf files
    if [[ "$FILE" == *.tf ]]; then
        # Get the directory of the changed file
        DIR=$(dirname "$FILE")

        # Call generate.sh for the entire module directory when a .tf file changes
        ./scripts/generate.sh "$DIR"

        # Check if it's the second time (after the first run) that generate.sh has been called
        if [ -f "$FIRST_RUN_FLAG" ]; then
            # Remove the first run flag, indicating that future runs are post-first execution
            rm $FIRST_RUN_FLAG

            # Start mkdocs serve on the second run only
            start_mkdocs_serve
        fi
    fi
done


