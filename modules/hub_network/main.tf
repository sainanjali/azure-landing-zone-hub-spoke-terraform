resource "azurerm_resource_group" "hub_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "hub_vnet" {
  name                = var.hub_vnet_name
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  address_space       = var.hub_address_space
  tags                = var.tags
}

# Subnets provisioned dynamically with for_each map
resource "azurerm_subnet" "hub_subnets" {
  for_each = var.hub_subnets

  name                                          = each.key
  resource_group_name                           = azurerm_resource_group.hub_rg.name
  virtual_network_name                          = azurerm_virtual_network.hub_vnet.name
  address_prefixes                              = each.value.address_prefixes
  service_endpoints                             = each.value.service_endpoints
  private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
}

# Network Security Group for standard management subnets (AzureFirewallSubnet & AzureBastionSubnet have native requirements)
resource "azurerm_network_security_group" "hub_mgmt_nsg" {
  name                = "${var.hub_vnet_name}-mgmt-nsg"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  security_rule {
    name                       = "Allow-SSH-Internal"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Allow-HTTPS-Internal"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}
