variable "project_id" {
  description = "The unique identifier for the Google Cloud project where the resources will be created. This ID ensures that the resources are associated with the correct project context and helps in managing billing and permissions."
}

variable "service_account_display_name" {
  description = "The display name for the service account, which is a user-friendly identifier for the service account in the Google Cloud Console. This helps team members quickly recognize the purpose of the service account. The default value is 'GitHub Actions Service Account'."
  type        = string
  default     = "GitHub Actions Service Account"
}

variable "service_account_description" {
  description = "A descriptive text that outlines the purpose of the service account. This information is displayed in the Google Cloud Console and can help users understand its intended use. The default description is 'Service account for workload identity'."
  type        = string
  default     = "Service account for workload identity"
}

variable "pool_id" {
  type        = string
  description = "The unique identifier for the Workload Identity Pool. This ID must be 4-32 characters in length and can include lowercase letters, numbers, and hyphens. It should not start with 'gcp-'. The pool ID is essential for uniquely identifying the identity pool within the Google Cloud project."
}

variable "pool_display_name" {
  type        = string
  description = "The display name for the Workload Identity Pool, which is used in the Google Cloud Console for easy identification. This name can be set to provide more context about the purpose of the identity pool. The default value is null, indicating that no display name has been set."
  default     = null
}

variable "pool_description" {
  type        = string
  description = "A description for the Workload Identity Pool that provides context about its usage. This is useful for documentation and helps team members understand the purpose of the pool. The default description is 'Workload Identity Pool managed by Terraform'."
  default     = "Workload Identity Pool managed by Terraform"
}

variable "pool_disabled" {
  type        = bool
  description = "A flag that indicates whether the Workload Identity Pool is disabled. If set to true, the pool will not be usable for authentication. The default value is false, meaning the pool is enabled."
  default     = false
}

# Identity pool provider

variable "provider_id" {
  type        = string
  description = "The unique identifier for the Workload Identity Pool Provider. This ID must be 4-32 characters in length and can include lowercase letters, numbers, and hyphens. It should not start with 'gcp-'. This provider ID is essential for uniquely identifying the provider within the identity pool."

}

variable "provider_display_name" {
  type        = string
  description = "The display name for the Workload Identity Pool Provider, used for easy identification in the Google Cloud Console. This name can provide context about the provider's purpose. The default value is null, indicating no display name has been set."
  default     = null
}

variable "provider_description" {
  type        = string
  description = "A description for the Workload Identity Pool Provider that outlines its purpose. This information is displayed in the Google Cloud Console and is useful for team members to understand the provider's function. The default description is 'Workload Identity Pool Provider managed by Terraform'."
  default     = "Workload Identity Pool Provider managed by Terraform"
}

variable "provider_disabled" {
  type        = bool
  description = "A flag that indicates whether the Workload Identity Pool Provider is disabled. When set to true, the provider will not be usable for authentication. The default value is false, meaning the provider is enabled."
  default     = false
}

variable "attribute_mapping" {
  type        = map(any)
  description = "A mapping of attributes that specify how claims in the token issued by the provider should be mapped to the Google Cloud identity. This mapping is essential for properly integrating external identities into Google Cloud IAM."
}

variable "attribute_condition" {
  type        = string
  description = "An expression that defines conditions under which the attribute mapping should apply. This is useful for fine-tuning access based on specific attributes present in the token. The default value is null, indicating that no conditions have been set."
  default     = null
}

variable "allowed_audiences" {
  type        = list(string)
  description = "A list of audiences that are allowed to authenticate through the Workload Identity Pool Provider. This helps in controlling which identities are accepted, enhancing security. The default value is an empty list, meaning no audiences are pre-defined."
  default     = []
}

variable "issuer_uri" {
  type        = string
  description = "The issuer URL of the Workload Identity Pool Provider, which is used to identify the source of the identity tokens. This URI is essential for verifying the authenticity of tokens issued by the provider."
}

# Service account impersonation

variable "github_wif_service_account_name" {
  description = "Name of the service account to be impersonated by the Workload Identity Federation."
  type        = string
}

variable "service_accounts" {
  type = list(object({
    name           = string
    attribute      = string
    all_identities = bool
  }))
  description = "Service Account resource names and corresponding provider attributes"
}
