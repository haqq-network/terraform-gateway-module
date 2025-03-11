resource "google_compute_global_address" "gateway" {
  name = var.gateway_address_name
}

resource "google_certificate_manager_certificate" "gateway" {
  for_each = tomap({
    for v in var.gateway_certificates : v.domain => v
  })

  name = each.value.domain
  self_managed {
    pem_certificate = each.value.certificate
    pem_private_key = each.value.key
  }
}

resource "google_certificate_manager_certificate_map" "gateway" {
  name = "gateway"
}

resource "google_certificate_manager_certificate_map_entry" "gateway" {
  for_each = google_certificate_manager_certificate.gateway

  name         = each.value.name
  map          = google_certificate_manager_certificate_map.gateway.name
  certificates = [google_certificate_manager_certificate.gateway[each.key].id]
  hostname     = each.value.name
}
