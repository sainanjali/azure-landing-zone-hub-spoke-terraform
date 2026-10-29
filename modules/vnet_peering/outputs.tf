output "hub_to_spoke_peerings" {
  value       = { for k, v in azurerm_virtual_network_peering.hub_to_spoke : k => v.id }
  description = "IDs of Hub-to-Spoke peering connections."
}

output "spoke_to_hub_peerings" {
  value       = { for k, v in azurerm_virtual_network_peering.spoke_to_hub : k => v.id }
  description = "IDs of Spoke-to-Hub peering connections."
}
