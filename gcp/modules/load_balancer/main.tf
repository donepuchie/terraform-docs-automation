# Managed SSL Certificate
resource "google_compute_managed_ssl_certificate" "frontend_ssl_cert" {
  name = var.ssl_cert_name
  
  managed {
    domains = var.ssl_cert_domains
  }
}

# Serverless NEG for Cloud Run
resource "google_compute_region_network_endpoint_group" "cloud_run_neg" {
  name                  = var.neg_name
  network_endpoint_type = "SERVERLESS"
  region                = var.region

  cloud_run {
    service = var.cloud_run_service_name
  }
}

# Backend Service
resource "google_compute_backend_service" "cloud_run_backend" {
  name        = var.backend_service_name
  project     = var.project_id
  protocol    = "HTTPS"  # Change to "HTTPS" if using HTTPS for Cloud Run
  port_name   = "http"
  timeout_sec = 30

  backend {
    group = google_compute_region_network_endpoint_group.cloud_run_neg.id
  }
}

# URL Map
resource "google_compute_url_map" "default" {
  name            = var.url_map_name
  default_service = google_compute_backend_service.cloud_run_backend.id

  host_rule {
    hosts        = var.hosts  
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.cloud_run_backend.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.cloud_run_backend.id
    }
  }
}

# Target HTTPS Proxy
resource "google_compute_target_https_proxy" "default" {
  name             = var.https_proxy_name
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.frontend_ssl_cert.id]
}

# HTTP-to-HTTPS resources
resource "google_compute_url_map" "https_redirect" {
  name = format("%s-https-redirect", var.https_redirect_name)  # Use format for cleaner naming

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_target_http_proxy" "https_redirect" {
  name   = format("%s-http-proxy", var.https_redirect_name)  # Use format for cleaner naming
  url_map = google_compute_url_map.https_redirect.id
}

resource "google_compute_global_forwarding_rule" "https_redirect" {
  name       = format("%s-fwdrule-http", var.https_redirect_name)  # Use format for cleaner naming
  target     = google_compute_target_http_proxy.https_redirect.id
  port_range = "80"
  ip_address  = google_compute_global_address.ipv4.address
}

# Global Forwarding Rule for HTTPS
resource "google_compute_global_forwarding_rule" "https_rule" {
  name        = var.forwarding_rule_name
  target      = google_compute_target_https_proxy.default.id
  port_range  = "443"
  load_balancing_scheme = "EXTERNAL"
  ip_address = google_compute_global_address.ipv4.address
}

resource "google_compute_global_address" "ipv4" {
  name        = "${var.global_ip_name}-ipv4"  # Unique name for the IPv4 address
  address_type = "EXTERNAL"                     
  ip_version   = "IPV4"                         
}

# Optional: IPv6 Global IP Address (conditionally created if enabled)
resource "google_compute_global_address" "ipv6" {
  count        = var.enable_ipv6 ? 1 : 0  # Only create if IPv6 is enabled
  name         = format("%s-ipv6", var.global_ip_name)  # Unique name for the IPv6 address
  address_type = "EXTERNAL"                      
  ip_version   = "IPV6"                           
}

