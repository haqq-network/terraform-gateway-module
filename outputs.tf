output "gateway_ip_address" {
  value       = google_compute_global_address.this.address
  description = "Gateway IP Address"
}
