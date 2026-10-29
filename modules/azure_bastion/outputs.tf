output "bastion_id" {
  value       = azurerm_bastion_host.bastion.id
  description = "Azure Bastion Resource ID"
}

output "bastion_dns_name" {
  value       = azurerm_bastion_host.bastion.dns_name
  description = "FQDN for Azure Bastion"
}
