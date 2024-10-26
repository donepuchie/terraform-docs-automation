# Input Variables for the Load Balancer
variable "project_id" {
  description = "The unique identifier for the Google Cloud project where the load balancer resources will be created. This ID associates the load balancer with the correct project context for billing and resource management."
}

variable "ssl_cert_name" {
  description = "The name for the SSL certificate that will be used to secure communications for the load balancer. This certificate is essential for enabling HTTPS traffic and ensuring data integrity and security."
  type        = string
}

variable "ssl_cert_domains" {
  description = "A list of domain names for which the SSL certificate will be valid. This variable specifies the domains that clients can use to access the load balancer over HTTPS, helping to define the certificate's scope."
  type        = list(string)
}

variable "neg_name" {
  description = "The name of the Network Endpoint Group (NEG) that will be used to route traffic to the Cloud Run service. This NEG facilitates the connection between the load balancer and the Cloud Run service, enabling effective traffic management."
  type        = string
}

variable "region" {
  description = "The geographic region where the load balancer and its associated resources will be deployed. This value helps in optimizing latency and ensuring that resources are located close to users."
  type        = string
}

variable "cloud_run_service_name" {
  description = "The name of the Cloud Run service that will handle incoming requests routed through the load balancer. This service must be defined and deployed to process traffic appropriately."
  type        = string
}

variable "backend_service_name" {
  description = "The name of the backend service that defines how requests are routed to the Cloud Run service. This variable outlines the configuration for load balancing and health checks to ensure high availability."
  type        = string
}

variable "url_map_name" {
  description = "The name of the URL map that directs incoming traffic based on the request URL. This map determines how traffic is routed to backend services, allowing for flexible handling of different URL patterns."
  type        = string
}

variable "hosts" {
  description = "Hosts for the URL map"
  type        = list(string)
}

variable "https_proxy_name" {
  description = "The name of the HTTPS proxy that will handle secure traffic for the load balancer. This proxy is responsible for managing SSL termination and routing requests to the appropriate backend services."
  type        = string
}

variable "forwarding_rule_name" {
  description = "The name of the forwarding rule that directs traffic to the load balancer. This rule defines how traffic is routed to the appropriate backend services based on IP addresses and protocols."
  type        = string
}

variable "global_ip_name" {
  description = "The name of the global IP address that will be associated with the load balancer. This IP address is used to expose the load balancer to the internet and direct traffic from users to the load balancer."
  type        = string
}

variable "https_redirect_name" {
  description = "The base name for the HTTPS redirect resources that will automatically redirect HTTP traffic to HTTPS. This is important for enhancing security by ensuring that all traffic is encrypted."
  type        = string
}

variable "enable_ipv6" {
  description = "Set to true to create an AAAA record for IPv6"
  type        = bool
  default     = false
}
