resource "google_compute_global_address" "this" {
  name = var.gateway_address_name
}

resource "google_certificate_manager_certificate" "this" {
  for_each = tomap({ for v in var.gateway_certificates : v.domain => v })

  name = replace(each.value.domain, ".", "-")
  self_managed {
    pem_certificate = each.value.pem_certificate
    pem_private_key = each.value.pem_private_key
  }
}

resource "google_certificate_manager_certificate_map" "this" {
  name = "gateway"
}

resource "google_certificate_manager_certificate_map_entry" "this" {
  for_each = tomap({ for v in var.gateway_certificates : v.domain => v })

  name         = replace(each.value.domain, ".", "-")
  map          = google_certificate_manager_certificate_map.this.name
  certificates = [google_certificate_manager_certificate.this[each.key].id]
  hostname     = each.value.domain
}
