variable "resource_group_name" {
  type        = string
  description = "Resource Group Name."
}

variable "dns_zones" {
  type        = list(string)
  description = "List of Private DNS zone domain names to create."
}

variable "vnet_links" {
  type = map(object({
    vnet_id               = string
    registration_enabled = optional(bool, false)
  }))
  description = "Map of virtual networks to link to private DNS zones."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}
