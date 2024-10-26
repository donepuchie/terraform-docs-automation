output "enabled_apis" {
  value = [for api in google_project_service.required_apis : api.service]
}

