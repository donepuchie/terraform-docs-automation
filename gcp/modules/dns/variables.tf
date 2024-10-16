variable "dns_zone" {
  description = "The name of the DNS zone"
  type        = string
}

variable "dns_name" {
  description = "The DNS name of the zone (must end with a dot, e.g., 'example.com.')"
  type        = string
}

variable "subdomain" {
  description = "The subdomain for which the DNS record is created"
  type        = string
}

variable "dns_ttl" {
  description = "Time-to-live for DNS records (in seconds)"
  type        = number
  default     = 300  # Default TTL is 5 minutes
}

variable "a_record_ip" {
  description = "IPv4 address for the A record"
  type        = string
}

variable "enable_ipv6" {
  description = "Set to true to create an AAAA record for IPv6"
  type        = bool
  default     = false
}

variable "aaaa_record_ip" {
  description = "IPv6 address for the AAAA record"
  type        = string
  default     = ""  # Default is empty, IPv6 will be optional
}
