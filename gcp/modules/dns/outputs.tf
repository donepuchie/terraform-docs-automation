output "dns_zone_name" {
  description = "The name of the DNS zone"
  value       = google_dns_managed_zone.dns_zone.name
}

output "dns_zone_dns_name" {
  description = "The DNS name of the zone"
  value       = google_dns_managed_zone.dns_zone.dns_name
}

output "dns_a_record_name" {
  description = "The name of the A record"
  value       = google_dns_record_set.a_record.name
}

output "dns_aaaa_record_name" {
  description = "The name of the AAAA record (if enabled)"
  value       = var.enable_ipv6 ? google_dns_record_set.aaaa_record[0].name : null
}

