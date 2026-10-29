variable "environment" {
  type        = string
  description = "Target environment (dev, staging, prod)."
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Primary Azure deployment region."
  default     = "eastus2"
}

variable "hub_vnet_name" {
  type        = string
  default     = "vnet-hub-dev-eastus2"
}

variable "hub_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "hub_subnets" {
  type = map(object({
    address_prefixes                          = list(string)
    service_endpoints                         = optional(list(string), [])
    private_endpoint_network_policies_enabled = optional(bool, true)
  }))
}

variable "spoke_vnets" {
  type = map(object({
    address_space = list(string)
    subnets = map(object({
      address_prefixes  = list(string)
      service_endpoints = optional(list(string), [])
    }))
  }))
}

variable "dns_zones" {
  type        = list(string)
  default     = [
    "privatelink.eastus2.azmk8s.io",
    "privatelink.vaultcore.azure.net",
    "privatelink.blob.core.windows.net",
    "privatelink.azurecr.io"
  ]
}

variable "tags" {
  type        = map(string)
  default     = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "Enterprise-Landing-Zone"
    Owner       = "Anjali Sain"
  }
}
