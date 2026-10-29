output "hub_vnet_id" {
  value       = module.hub.hub_vnet_id
  description = "Central Hub VNet Resource ID"
}

output "azure_firewall_private_ip" {
  value       = module.azure_firewall.firewall_private_ip
  description = "Azure Firewall Private IP (Central Gateway)"
}

output "bastion_dns_name" {
  value       = module.azure_bastion.bastion_dns_name
  description = "Azure Bastion FQDN for zero-public-IP administrative access"
}

output "spoke_vnet_ids" {
  value       = module.spokes.spoke_vnet_ids
  description = "Map of all provisioned Spoke Virtual Networks"
}

output "peering_status" {
  value       = {
    hub_to_spokes = module.vnet_peering.hub_to_spoke_peerings
    spokes_to_hub = module.vnet_peering.spoke_to_hub_peerings
  }
  description = "Bidirectional Peering Connection IDs"
}
