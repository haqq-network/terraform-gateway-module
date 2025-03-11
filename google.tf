resource "google_compute_global_address" "gateway" {
  name = var.gateway_address_name
}

resource "google_certificate_manager_certificate" "gateway" {
  for_each = tomap({
    # Key change is required by Terraform best practices.
    for v in var.gateway_certificates : replace(replace(v.domain, "-", "_"), ".", "_") => v
  })

  # Name change is required by the API specification.
  name = replace(replace(each.value.domain, "_", "-"), ".", "-")
  labels = {
    domain = each.value.domain
  }
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
  hostname     = each.value.labels.domain
}
