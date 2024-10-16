variable "name" {
  description = "The name of the Cloud Run service, which is used to identify the service within Google Cloud. This value should be unique within the project and is typically a short, descriptive name for the service being deployed."
  type        = string
}

variable "region" {
  description = "The geographical region where the Cloud Run service will be hosted. This affects the latency and availability of the service for users in different locations. Choose a region that is closest to your target user base."
  type        = string
}

variable "project_id" {
  description = "The unique identifier for the Google Cloud project in which the Cloud Run service and related resources will be created. This is required to ensure that resources are managed within the correct project context."
  type        = string
}

variable "github_owner" {
  description = "The owner of the GitHub repository, which can be either a personal account or an organization name. This value is used for integrating GitHub Actions or other GitHub-related configurations."
  type        = string
}

variable "image_name" {
  description = "The name of the Docker image stored in the GitHub Container Registry (or another container registry). This image is what Cloud Run will use to run the service, and it must be accessible by Cloud Run at the time of deployment."
  type        = string
}

variable "service_account_email" {
  description = "The email address of the Google Cloud service account that will be associated with the Cloud Run service. This service account is used to grant permissions to the service and allows it to interact with other Google Cloud resources securely."
  type        = string
}

variable "github_service_account_email" {
  description = "The email of the GitHub service account that will be granted the 'Service Account User' role. This allows the GitHub Actions workflows to impersonate the service account and perform actions on behalf of the Cloud Run service."
  type        = string
}

variable "traffic_percent" {
  description = "The percentage of traffic that will be directed to the new revision of the Cloud Run service. This is useful for gradual rollouts or A/B testing, allowing you to control how much traffic is directed to new deployments. The default value is set to 100, meaning all traffic will go to the latest revision."
  type        = number
  default     = 100
}

variable "memory_limit" {
  description = "The maximum amount of memory that the Cloud Run service can use, specified in a format accepted by Google Cloud (e.g., '512Mi', '1Gi'). This value impacts the performance of the service, especially for memory-intensive applications. The default is set to '512Mi'."
  type        = string
  default     = "512Mi"
}

variable "cpu_limit" {
  description = "The maximum amount of CPU that the Cloud Run service can use, defined as a numeric value. This limit affects how much processing power is allocated to the service. The default value is set to '1', which indicates that the service can use one virtual CPU."
  type        = string
  default     = "1"
}
