resource "google_cloud_run_service" "terraform_docs_service" {
  name     = var.name
  location = var.region
  project  = var.project_id

  # Annotations for the Service level
  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "all"
    }
  }

  template {
    spec {
      containers {
      
        image = var.image_name

        resources {
          limits = {
            memory = var.memory_limit
            cpu    = var.cpu_limit
          }
        }
      }
    }
  }

  traffic {
    percent         = var.traffic_percent
    latest_revision = true
  }
}

# --- IAM Policy Bindings ---
# IAM Policy Binding for Cloud Run Service Access
resource "google_cloud_run_service_iam_member" "cloud_run_invoker" {
  project = var.project_id
  service = google_cloud_run_service.terraform_docs_service.name
  role    = "roles/run.invoker"
  member  = "allUsers"
}

# Grant Service Account User role
resource "google_project_iam_member" "github_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member = "serviceAccount:${var.github_service_account_email}"
}

# IAM Binding for Cloud Run Developer Role
resource "google_project_iam_member" "run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member = "serviceAccount:${var.github_service_account_email}"
}
