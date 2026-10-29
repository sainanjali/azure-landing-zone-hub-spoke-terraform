output "firewall_id" {
  value       = azurerm_firewall.firewall.id
  description = "Azure Firewall Resource ID"
}

output "firewall_private_ip" {
  value       = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
  description = "Azure Firewall Private IP Address used as next-hop for Route Tables."
}

output "firewall_public_ip" {
  value       = azurerm_public_ip.fw_pip.ip_address
  description = "Azure Firewall Public Egress IP"
}
