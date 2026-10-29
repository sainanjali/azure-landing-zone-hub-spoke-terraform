variable "resource_group_name" {
  type        = string
  description = "Name of the resource group for the Hub network."
}

variable "location" {
  type        = string
  description = "Azure region where resources will be deployed."
}

variable "hub_vnet_name" {
  type        = string
  description = "Name of the Central Hub Virtual Network."
}

variable "hub_address_space" {
  type        = list(string)
  description = "Address space for the Hub VNet (e.g. ['10.0.0.0/16'])."
}

variable "hub_subnets" {
  type = map(object({
    address_prefixes                          = list(string)
    service_endpoints                         = optional(list(string), [])
    private_endpoint_network_policies_enabled = optional(bool, true)
  }))
  description = "Map of subnets to create inside the Hub Virtual Network using for_each."
}

variable "tags" {
  type        = map(string)
  description = "Resource tags applied to all Hub resources."
  default     = {}
}
