output "zone_ids" {
  value       = { for k, v in azurerm_private_dns_zone.zones : k => v.id }
  description = "Map of DNS zone names to Resource IDs."
}
