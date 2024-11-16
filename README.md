
# Automated Terraform Module Documentation System

## Containerized, Continuous Documentation for Terraform Modules on GCP

### Overview

The **Automated Terraform Module Documentation System** streamlines the generation, updating, and hosting of Terraform module documentation. This solution leverages a containerized approach on Google Cloud Platform (GCP) to ensure Terraform documentation is consistently up-to-date, easily accessible, and deployed automatically with each code change.

By integrating documentation generation into the CI/CD pipeline, this system reduces manual intervention and provides a robust method for maintaining accurate infrastructure documentation.


## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Terraform](https://www.terraform.io/downloads.html)
- Access to **Google Cloud Platform (GCP)** with appropriate permissions.
- **GitHub** repository for source code.
## Usage/Examples

1. **Clone the Repository**
   ```bash
   git https://github.com/donepuchie/terraform-docs-automation
   cd terraform-docs-automation

2. **Create a terraform.tfvars file with module-specific parameters. Below is an example:**
```javascript
# Artifact Registry settings
repository_id = "your-docker-repo"

# Cloud Run settings
name                          = "your-cloud-run-service"
github_owner                  = "your-github-username"
image_name                    = "region-docker.pkg.dev/your-project-id/your-docker-repo/your-image:tag"
traffic_percent               = 100
cpu_limit                     = "1"

# Load Balancer settings
https_redirect_name = "your-redirect-name"
ssl_cert_name       = "your-ssl-cert-name"
ssl_cert_domains    = ["your-domain.com"]
neg_name            = "your-neg-name"
backend_service_name = "your-backend-service-name"
url_map_name        = "your-url-map-name"
hosts               = ["your-domain.com"]
https_proxy_name    = "your-https-proxy-name"
forwarding_rule_name = "your-forwarding-rule-name"
global_ip_name      = "your-global-ip-name"

# DNS settings
dns_zone     = "your-dns-zone"
dns_name     = "your-domain.com."
dns_ttl      = 300

# Enable IPv6 if needed
enable_ipv6 = false

# Workload Identity Pool configuration
project_id            = "your-project-id"
pool_id               = "your-pool-id"
pool_display_name     = "your-pool-display-name"
provider_id           = "your-provider-id"
provider_display_name = "your-provider-display-name"
issuer_uri            = "https://token.actions.githubusercontent.com"

# Service Account for GitHub Actions
github_wif_service_account_name = "your-service-account-name"
service_account_display_name    = "your-service-account-display-name"

```




## Docker Deployment
The Dockerfile deploys an MkDocs application running in development mode on Cloud Run. While this setup is suitable for demonstration and testing, it does not leverage Cloud Run's scaling capabilities properly and is not recommended for production. For a production deployment, refactor the Dockerfile to run the site using a more robust web server like Nginx or Apache to ensure improved performance, better scalability, and adherence to production-grade best practices.



3. **Containerize Locally for Testing**
   ```bash
   docker build -t terraform-docs-automation .
   docker run -p 8080:80 terraform-docs-automation
## Continuous Integration and Continuous Delivery (CI/CD)
This repository includes a CI/CD workflow set up with GitHub Actions. The workflow performs the following tasks:

- Builds the Docker image.
- Pushes the Docker image to Google Cloud Run, authenticating using Workload Identity.
The workflow is triggered on push to the main branch and on changes to Terraform files (with a .tf extension). It is configured to deploy automatically with every update.

To configure the CI workflow for your own project, ensure that you have the necessary permissions and credentials set up for Google Cloud Workload Identity.

You can modify the workflow configuration in the .github/workflows/build.yml file to suit your needs.

**Additionally Test CI/CD Workflows Locally (Optional). Install act for running GitHub Actions locally:**
   ```bash
   act 

 ```
## Intended Usage

The goal of this project is to provide a base for users to pull the Terraform modules, add any additional Terraform modules as needed, and host the documentation on any cloud service of their choice. Please note that while the current implementation is focused on GCP, hosting on other cloud services may require significant refactoring.

Enjoy
