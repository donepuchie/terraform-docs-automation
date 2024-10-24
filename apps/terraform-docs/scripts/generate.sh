#!/bin/bash

# Check if MODULES_DIR or specific file is passed as an argument
if [ -z "$1" ]; then
    echo "Error: No directory or file provided."
    echo "Usage: ./generate.sh <module_directory|file.tf>"
    exit 1
fi

# Check if the argument is a directory or file
if [ -d "$1" ]; then
    MODULES_DIR="$1"
elif [ -f "$1" ]; then
    TF_FILE="$1"
    MODULES_DIR=$(dirname "$TF_FILE")
else
    echo "Error: Invalid input. Not a directory or file."
    exit 1
fi

# Ensure /docs directory exists
mkdir -p /usr/src/app/docs

# Convert MODULES_DIR to absolute path for consistency
MODULES_DIR=$(realpath "$MODULES_DIR")

# Loop over all Terraform module directories and generate docs in batch
for dir in "$MODULES_DIR"/*/; do
    if [ -d "$dir" ]; then
        MODULE_NAME=$(basename "$dir")
        OUTPUT_MD="/usr/src/app/docs/${MODULE_NAME}.md"

        echo "Generating documentation for module: $MODULE_NAME..."

        # Generate Terraform documentation for the module
        terraform-docs markdown table "$dir" > "$OUTPUT_MD"
        if [ $? -ne 0 ]; then
            echo "Error: terraform-docs command failed for $MODULE_NAME"
            exit 1
        fi

        echo "Documentation generated for $MODULE_NAME and saved to $OUTPUT_MD"
    fi
done

# Create mkdocs.yml if it doesn't exist
MKDOCS_YML="/usr/src/app/mkdocs.yml"
if [ ! -f "$MKDOCS_YML" ]; then
    echo "Creating mkdocs.yml..."
    cat <<EOF > "$MKDOCS_YML"
site_name: The Terraform Module Compendium
docs_dir: "docs"
theme:
  name: material
  features:
    - navigation.tabs
    - navigation.sections
    - toc.integrate
    - navigation.top
    - search.suggest
    - search.highlight
    - content.tabs.link
    - content.code.annotation
    - content.code.copy
  language: en
  palette:
  - scheme: default
    toggle:
      icon: material/toggle-switch-off-outline
      name: Switch to dark mode
    primary: teal
    accent: purple
  - scheme: slate
    toggle:
      icon: material/toggle-switch
      name: Switch to light mode
    primary: teal
    accent: lime
plugins:
  - social
  - search
extra:
  social:
    - icon: fontawesome/brands/github-alt
      link: https://github.com/Donepuchie
    - icon: fontawesome/brands/linkedin
      link: https://www.linkedin.com/in/don-epuchie/
markdown_extensions:
  - pymdownx.highlight:
      anchor_linenums: true
  - pymdownx.inlinehilite
  - pymdownx.snippets
  - admonition
  - pymdownx.arithmatex:
      generic: true
  - footnotes
  - pymdownx.details
  - pymdownx.superfences
  - pymdownx.mark
  - attr_list
copyright: '&copy; 2024 Don Epuchie'
EOF
    echo "mkdocs.yml created."
else
    echo "mkdocs.yml already exists, skipping creation."
fi

# Create index.md if it doesn't exist
INDEX_MD="/usr/src/app/docs/index.md"
if [ ! -f "$INDEX_MD" ]; then
    echo "Creating index.md..."
    cat <<EOF > "$INDEX_MD"
<div style="text-align: center; margin-top: 20px;">
    <h1 style="font-size: 2.5rem; color: #4A90E2;">Terraform Module Documentation Portal</h1>
    <p style="font-size: 1.2rem; color: #888;">Automated, Consistent, and Clear Documentation for Terraform Modules</p>
</div>

## 🚀 Overview
Welcome to the **Terraform Module Compendium**!

This repository contains a collection of Terraform modules designed to streamline infrastructure management on Google Cloud Platform (GCP). Each module comes with an automatically generated README, providing an up-to-date summary of its purpose, inputs, outputs, and usage examples.

The automation ensures that the documentation always reflects the latest changes made to the modules, making it easier to stay informed about their configurations and features.

### What You'll Find Here
- 📄 **Input Variables**
- 📊 **Output Values**
- 🧰 **Providers**
- 🏗️ **Resources**

## 💡 How to Use This Portal
To view the README for a specific module, use the **sidebar navigation**.

<div style="background-color: #2c3e50; padding: 10px; color: #ecf0f1;">
  <strong>Tip:</strong> Regenerate the README with <code>generate.sh</code>.
</div>

\`\`\`sh
./generate.sh
\`\`\`
EOF
    echo "index.md created."
else
    echo "index.md already exists, skipping creation."
fi

# Build MkDocs documentation
echo "Building MkDocs site in batch..."
mkdocs build
if [ $? -ne 0 ]; then
    echo "Error: MkDocs build failed."
    exit 1
fi

echo "MkDocs site successfully built."

# Serve MkDocs site within the container
echo "Starting MkDocs server..."
mkdocs serve --dev-addr=0.0.0.0:8080
