variable "resource_group_name" {
  type        = string
  description = "Resource group for the Firewall."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "firewall_name" {
  type        = string
  description = "Azure Firewall resource name."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID of the AzureFirewallSubnet in Hub VNet."
}

variable "sku_name" {
  type        = string
  description = "SKU Name of the firewall (AZFW_VNet or AZFW_Hub)."
  default     = "AZFW_VNet"
}

variable "sku_tier" {
  type        = string
  description = "SKU Tier (Standard or Premium)."
  default     = "Standard"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}
