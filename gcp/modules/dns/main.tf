# Create DNS Zone
resource "google_dns_managed_zone" "dns_zone" {
  name     = var.dns_zone
  dns_name = var.dns_name

}

# A record for IPv4
resource "google_dns_record_set" "a_record" {
  name         = format("%s.%s", var.subdomain, var.dns_name)
  type         = "A"
  ttl          = var.dns_ttl
  managed_zone = var.dns_zone
  rrdatas      = [var.a_record_ip]  # IPv4 address from the load balancer
}

# AAAA record for IPv6, created only if IPv6 is enabled
resource "google_dns_record_set" "aaaa_record" {
  count        = var.enable_ipv6 ? 1 : 0
  name         = format("%s.%s", var.subdomain, var.dns_name)
  type         = "AAAA"
  ttl          = var.dns_ttl
  managed_zone = var.dns_zone
  rrdatas      = [var.aaaa_record_ip]  # IPv6 address from the load balancer (conditionally created)
}