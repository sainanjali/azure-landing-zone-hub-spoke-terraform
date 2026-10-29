output "resource_group_name" {
  value       = azurerm_resource_group.hub_rg.name
  description = "Hub Resource Group Name"
}

output "hub_vnet_id" {
  value       = azurerm_virtual_network.hub_vnet.id
  description = "Hub Virtual Network Resource ID"
}

output "hub_vnet_name" {
  value       = azurerm_virtual_network.hub_vnet.name
  description = "Hub Virtual Network Name"
}

output "hub_subnet_ids" {
  value       = { for k, v in azurerm_subnet.hub_subnets : k => v.id }
  description = "Map of Hub subnet names to subnet resource IDs."
}
