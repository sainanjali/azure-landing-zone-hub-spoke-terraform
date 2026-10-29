variable "resource_group_name" {
  type        = string
  description = "Resource Group Name."
}

variable "location" {
  type        = string
  description = "Azure Region."
}

variable "bastion_name" {
  type        = string
  description = "Azure Bastion Host Name."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID of AzureBastionSubnet."
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "Bastion SKU (Basic or Standard)."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}
