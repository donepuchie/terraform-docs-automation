output "pool_id" {
  description = "Identifier for the pool"
  value       = google_iam_workload_identity_pool.pool.id
}

output "pool_state" {
  description = "State of the pool"
  value       = google_iam_workload_identity_pool.pool.state
}

output "pool_name" {
  description = "Name for the pool"
  value       = google_iam_workload_identity_pool.pool.name
}

output "provider_id" {
  description = "Identifier for the provider"
  value       = google_iam_workload_identity_pool_provider.provider.id
}

output "provider_state" {
  description = "State of the provider"
  value       = google_iam_workload_identity_pool_provider.provider.state
}

output "provider_name" {
  description = "Name for the provider"
  value       = google_iam_workload_identity_pool_provider.provider.name
}
output "github_actions_service_account_email" {
  description = "Email address of the GitHub Actions service account"
  value       = google_service_account.github_actions_sa.email
}

output "github_actions_service_account_name" {
  description = "name of the GitHub Actions service account"
  value = google_service_account.github_actions_sa.name
}
