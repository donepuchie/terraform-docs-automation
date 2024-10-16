#!/bin/bash

# Check if an argument is passed
if [ -z "$1" ]; then
    echo "Error: No directory or file provided."
    echo "Usage: ./generate.sh <module_directory|file.tf>"
    exit 1
fi

# Check if the argument is a file or directory
if [ -d "$1" ]; then
    # Argument is a directory
    MODULE_DIR="$1"
else
    # Argument is a file, extract the directory
    TF_FILE="$1"
    MODULE_DIR=$(dirname "$TF_FILE")
fi

# Get the module folder name and construct the output filename
MODULE_NAME=$(basename "$MODULE_DIR")
OUTPUT_MD="/usr/src/app/docs/${MODULE_NAME}.md"

# Ensure the /docs and /site directories exist
mkdir -p /usr/src/app/docs
mkdir -p /usr/src/app/site

# Convert MODULE_DIR to an absolute path
MODULE_DIR=$(realpath "$MODULE_DIR")

# Generate Terraform documentation using terraform-docs
terraform-docs markdown table "$MODULE_DIR" > "$OUTPUT_MD"
if [ $? -ne 0 ]; then
    echo "Error: terraform-docs command failed for $MODULE_DIR"
    exit 1
fi

# Wait until the output file is generated before proceeding
while [ ! -f "$OUTPUT_MD" ]; do
    sleep 1
done

echo "Documentation generated for $MODULE_NAME and saved to $OUTPUT_MD"

# Create or update mkdocs.yml if it doesn't exist
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
copyright: '&copy; 2024 <a href="https://github.com/Donepuchie" target="_blank" rel="noopener">Don Epuchie</a>'
EOF
    echo "mkdocs.yml created."
else
    echo "mkdocs.yml already exists, skipping creation."
fi

# Create or update the index.md file in the docs directory
INDEX_MD="/usr/src/app/docs/index.md"
if [ ! -f "$INDEX_MD" ]; then
    echo "Creating index.md..."
    cat <<EOF > "$INDEX_MD"
<div style="text-align: center; margin-top: 20px;">
    <h1 style="font-size: 2.5rem; color: #4A90E2;">Terraform Module Documentation Portal</h1>
    <p style="font-size: 1.2rem; color: #888; transition: color 0.3s;">Automated, Consistent, and Clear Documentation for Terraform Modules</p>
</div>

## 🚀 Overview
Welcome to the **Terraform Module Compendium**!

This repository contains a collection of Terraform modules designed to streamline infrastructure management on Google Cloud Platform (GCP). Each module comes with an automatically generated README, providing an up-to-date summary of its purpose, inputs, outputs, and usage examples.

The automation ensures that the documentation always reflects the latest changes made to the modules, making it easier to stay informed about their configurations and features.

To dive deeper into the specifics of each module, please explore the following sections, where you will find detailed descriptions and documentation.

### What You'll Find Here

- 📄 **Input Variables**: Details about the variables required by the module.
- 📊 **Output Values**: The values that are output by the module after its resources are created.
- 🧰 **Providers**: Information about the Terraform providers used in the module.
- 🏗️ **Resources**: The resources managed by the module.

## 💡 How to Use This Portal

To view the README for a specific Terraform module:

1. Use the **sidebar navigation** to select the module you're interested in.
2. Click on the module name to view its README.
3. The README is displayed in Markdown format, showing a clear and concise summary of the module's capabilities and usage.

<div style="background-color: #2c3e50; border-left: 5px solid #4A90E2; padding: 10px; margin: 20px 0; color: #ecf0f1; transition: background-color 0.3s, color 0.3s;">
    <strong>Tip:</strong> You can regenerate the README at any time using the provided <code style="color: #e74c3c;">generate.sh</code> script.
</div>

### Example Command to Generate README:

\`\`\`sh
./generate.sh
\`\`\`

EOF
    echo "index.md file created in the docs directory."
else
    echo "index.md already exists, skipping creation."
fi

# Build MkDocs documentation
mkdocs build 

# Notify that documentation has been generated
echo "MkDocs documentation generated."
