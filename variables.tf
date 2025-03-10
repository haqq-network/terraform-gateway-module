variable "gke_host" {
  type = string
}

variable "gke_token" {
  type = string
}

variable "gke_cluster_ca_certificate" {
  type = string
}

variable "gateway_namespace" {
  description = "Kubernetes namespace for the Gateway API resources"
  type        = string
  default     = "gateway"
}

variable "gateway_labels" {
  description = "Additional labels that will be applied to all Kubernetes objects"
  type        = map(string)
  default     = {}
}

variable "gateway_class_name" {
  description = <<-EOF
    GatewayClass name that Google's Gateway API supports.

    https://cloud.google.com/kubernetes-engine/docs/concepts/gateway-api#gatewayclass
    EOF
  type        = string
  default     = "gke-l7-global-external-managed"
}

variable "gateway_address_name" {
  description = "Name of the IP address resource that will be bound to the gateway"
  type        = string
  default     = "gateway"
}

variable "gateway_certificates" {
  description = "A list of certificates that will be mapped to the gateway"
  type = list(object({
    domain      = string
    certificate = string
    key         = string
  }))
}
