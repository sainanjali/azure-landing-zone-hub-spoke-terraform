variable "hub_vnet_name" {
  type        = string
  description = "Name of the Central Hub Virtual Network."
}

variable "hub_rg_name" {
  type        = string
  description = "Resource Group of the Hub VNet."
}

variable "hub_vnet_id" {
  type        = string
  description = "Resource ID of the Hub VNet."
}

variable "spokes_map" {
  type = map(object({
    id                  = string
    name                = string
    resource_group_name = string
  }))
  description = "Map of spokes for bidirectional peering."
}
