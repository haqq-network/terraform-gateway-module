locals {
  default_labels = {
    "app.kubernetes.io/managed-by" = "Terraform"
  }

  merged_labels = merge(
    local.default_labels,
    var.gateway_labels,
  )
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  token                  = var.cluster_token
  cluster_ca_certificate = var.cluster_ca_certificate
}

resource "kubernetes_namespace" "this" {
  metadata {
    name   = var.gateway_namespace
    labels = local.merged_labels
  }
}

resource "kubernetes_manifest" "gateway_default" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"
    metadata = {
      name      = "default"
      namespace = kubernetes_namespace.this.metadata[0].name
      labels    = local.merged_labels
      annotations = {
        "networking.gke.io/certmap" = google_certificate_manager_certificate_map.this.name
      }
    }
    spec = {
      gatewayClassName = var.gateway_class_name
      addresses = [
        {
          type  = "NamedAddress"
          value = var.gateway_address_name
        }
      ]
      listeners = [
        {
          name     = "http"
          protocol = "HTTP"
          port     = 80
        },
        {
          name     = "https"
          protocol = "HTTPS"
          port     = 443
          allowedRoutes = {
            namespaces = {
              from = "All"
            }
          }
        }
      ]
    }
  }
  field_manager {
    force_conflicts = true
    name            = "default"
  }
}

resource "kubernetes_manifest" "httproute_http_redirect" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "http-redirect"
      namespace = kubernetes_namespace.this.metadata[0].name
      labels    = local.merged_labels
    }
    spec = {
      parentRefs = [
        {
          name        = kubernetes_manifest.gateway_default.manifest.metadata.name
          sectionName = "http"
        }
      ]
      rules = [
        {
          filters = [
            {
              type = "RequestRedirect"
              requestRedirect = {
                scheme = "https"
              }
            }
          ]
        }
      ]
    }
  }
  field_manager {
    force_conflicts = true
    name            = "default"
  }
}
