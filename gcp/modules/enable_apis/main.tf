# Enable APIs for Cloud Run, Load Balancer, and Workload Identity
resource "google_project_service" "required_apis" {
  for_each = toset(local.required_apis)

  project = var.project_id
  service = each.value

  disable_on_destroy = false
}

# Use a local variable to improve readability
locals {
  required_apis = [
    "run.googleapis.com",                   # Cloud Run
    "compute.googleapis.com",               # Compute Engine (Load Balancer)
    "iam.googleapis.com",                   # IAM (Workload Identity)
    "iamcredentials.googleapis.com",        # IAM Credentials (Workload Identity)
    "cloudresourcemanager.googleapis.com",  # Resource Manager
    "servicenetworking.googleapis.com",     # Service Networking (optional for VPC)
    "sts.googleapis.com"
  ]
}
