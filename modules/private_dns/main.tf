# 1. Create Private DNS Zones using for_each
resource "azurerm_private_dns_zone" "zones" {
  for_each = toset(var.dns_zones)

  name                = each.value
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# 2. Flatten Zone-to-VNet combinations for for_each linking
locals {
  zone_links = flatten([
    for zone in var.dns_zones : [
      for vnet_key, vnet_val in var.vnet_links : {
        id                   = "${zone}-${vnet_key}"
        zone_name            = zone
        vnet_key             = vnet_key
        vnet_id              = vnet_val.vnet_id
        registration_enabled = vnet_val.registration_enabled
      }
    ]
  ])
}

resource "azurerm_private_dns_zone_virtual_network_link" "links" {
  for_each = { for l in local.zone_links : l.id => l }

  name                  = "${each.value.vnet_key}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.zones[each.value.zone_name].name
  virtual_network_id    = each.value.vnet_id
  registration_enabled  = each.value.registration_enabled
  tags                  = var.tags
}
