output "global_ip_v4" {
  description = "The global IPv4 address for the Load Balancer"
  value       = google_compute_global_address.ipv4.address
}

output "global_ip_v6" {
  description = "The global IPv6 address for the Load Balancer (if enabled)"
  value       = var.enable_ipv6 ? google_compute_global_address.ipv6[0].address : null
}

# In the load_balancer module's outputs.tf
output "url_map_url" {
  description = "The URL of the URL map"
  value       = google_compute_url_map.default.self_link
}