# 1. Hub to Spoke Peering (for_each over spokes)
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  for_each = var.spokes_map

  name                         = "hub-to-${each.key}"
  resource_group_name          = var.hub_rg_name
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = each.value.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

# 2. Spoke to Hub Peering (for_each over spokes)
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  for_each = var.spokes_map

  name                         = "${each.key}-to-hub"
  resource_group_name          = each.value.resource_group_name
  virtual_network_name         = each.value.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  depends_on = [azurerm_virtual_network_peering.hub_to_spoke]
}
