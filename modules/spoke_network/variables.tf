variable "resource_group_name" {
  type        = string
  description = "Name of the resource group hosting the Spokes."
}

variable "location" {
  type        = string
  description = "Azure region for deployment."
}

variable "firewall_private_ip" {
  type        = string
  description = "Private IP address of the Central Azure Firewall for default egress routing (0.0.0.0/0)."
}

variable "spoke_vnets" {
  type = map(object({
    address_space = list(string)
    subnets = map(object({
      address_prefixes  = list(string)
      service_endpoints = optional(list(string), [])
    }))
  }))
  description = "Hierarchical map of Spoke VNets and their respective subnets for for_each iteration."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all spoke resources."
  default     = {}
}
