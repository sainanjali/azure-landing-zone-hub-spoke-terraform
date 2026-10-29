resource "azurerm_resource_group" "spoke_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# 1. Provision each Spoke Virtual Network using for_each
resource "azurerm_virtual_network" "spokes" {
  for_each = var.spoke_vnets

  name                = each.key
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name
  address_space       = each.value.address_space
  tags                = var.tags
}

# 2. Flatten subnets to create them dynamically with for_each
locals {
  flattened_subnets = flatten([
    for vnet_name, vnet_data in var.spoke_vnets : [
      for subnet_name, subnet_data in vnet_data.subnets : {
        id                = "${vnet_name}-${subnet_name}"
        vnet_name         = vnet_name
        subnet_name       = subnet_name
        address_prefixes  = subnet_data.address_prefixes
        service_endpoints = subnet_data.service_endpoints
      }
    ]
  ])
}

resource "azurerm_subnet" "spoke_subnets" {
  for_each = { for s in local.flattened_subnets : s.id => s }

  name                 = each.value.subnet_name
  resource_group_name  = azurerm_resource_group.spoke_rg.name
  virtual_network_name = azurerm_virtual_network.spokes[each.value.vnet_name].name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints
}

# 3. Route Table per Spoke forcing 0.0.0.0/0 traffic through Central Hub Azure Firewall
resource "azurerm_route_table" "spoke_route_tables" {
  for_each = var.spoke_vnets

  name                          = "${each.key}-rt"
  location                      = azurerm_resource_group.spoke_rg.location
  resource_group_name           = azurerm_resource_group.spoke_rg.name
  disable_bgp_route_propagation = false

  route {
    name                   = "Default-To-Central-Firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }

  tags = var.tags
}

# 4. Associate Route Table with each Spoke Subnet
resource "azurerm_subnet_route_table_association" "spoke_rt_assoc" {
  for_each = { for s in local.flattened_subnets : s.id => s }

  subnet_id      = azurerm_subnet.spoke_subnets[each.key].id
  route_table_id = azurerm_route_table.spoke_route_tables[each.value.vnet_name].id
}
