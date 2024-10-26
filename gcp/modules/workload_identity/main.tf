# Workload Identity Pool
resource "google_iam_workload_identity_pool" "pool" {

  project  = var.project_id

  workload_identity_pool_id = var.pool_id
  display_name              = var.pool_display_name
  description               = var.pool_description
  disabled                  = var.pool_disabled
}


# Workload Identity Pool Provider for GitHub
resource "google_iam_workload_identity_pool_provider" "provider" {

  project  = var.project_id

  workload_identity_pool_id = google_iam_workload_identity_pool.pool.workload_identity_pool_id

  workload_identity_pool_provider_id = var.provider_id
  display_name                       = var.provider_display_name
  description                        = var.provider_description
  disabled                           = var.provider_disabled

  attribute_mapping   = var.attribute_mapping
  attribute_condition = var.attribute_condition
  oidc {
    allowed_audiences = var.allowed_audiences
    issuer_uri        = var.issuer_uri
  }
}


# Service Account for GitHub Actions
resource "google_service_account" "github_actions_sa" {
  account_id   = var.github_wif_service_account_name
  display_name = var.service_account_display_name
  project      = var.project_id
}

# IAM binding to allow GitHub Actions to impersonate the Service Account
# IAM binding to allow GitHub Actions to impersonate the Service Account
# IAM binding to allow GitHub Actions to impersonate the Service Account
resource "google_service_account_iam_member" "member" {
  for_each = { for index, account in var.service_accounts : index => account }

  service_account_id = each.value.name
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.pool.name}/${each.value.attribute}"
  role               = "roles/iam.workloadIdentityUser"
}

