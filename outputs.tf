output "gateway_ip_address" {
  value       = google_compute_global_address.gateway.address
  description = "Gateway IP Address"
}
