# terraform-gateway-module

A Terraform module that creates a GKE Gateway API resource using SSL
certificates (usually by Cloudflare).

## Usage

```hcl
module "gateway" {
  source = "..."

  gke_host                   = "..."
  gke_token                  = "..."
  gke_cluster_ca_certificate = "..."
  gateway_certificates = [
    {
      domain      = "alpha.example.com"
      certificate = "..."
      key         = "..."
    },
    {
      domain      = "beta.example.com"
      certificate = "..."
      key         = "..."
    }
  ]
}
```
