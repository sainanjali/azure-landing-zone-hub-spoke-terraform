output "spoke_vnet_ids" {
  value       = { for k, v in azurerm_virtual_network.spokes : k => v.id }
  description = "Map of Spoke VNet names to Resource IDs."
}

output "spoke_vnet_names" {
  value       = { for k, v in azurerm_virtual_network.spokes : k => v.name }
  description = "Map of Spoke VNet names."
}

output "spoke_subnet_ids" {
  value       = { for k, v in azurerm_subnet.spoke_subnets : k => v.id }
  description = "Map of flattened spoke subnet keys to subnet IDs."
}
