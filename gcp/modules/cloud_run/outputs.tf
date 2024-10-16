output "cloud_run_url" {
  value = element(google_cloud_run_service.terraform_docs_service.status, 0).url
}

output "cloud_run_service_name" {
  description = "The name of the Cloud Run service"
  value       = google_cloud_run_service.terraform_docs_service.name
}
