locals {
  hub_rg_name   = "rg-network-hub-${var.environment}-${var.location}"
  spoke_rg_name = "rg-network-spokes-${var.environment}-${var.location}"
}

# 1. Central Hub Network Module
module "hub" {
  source = "../../modules/hub_network"

  resource_group_name = locals.hub_rg_name
  location            = var.location
  hub_vnet_name       = var.hub_vnet_name
  hub_address_space   = var.hub_address_space
  hub_subnets         = var.hub_subnets
  tags                = var.tags
}

# 2. Azure Firewall Module in Hub
module "azure_firewall" {
  source = "../../modules/azure_firewall"

  resource_group_name = module.hub.resource_group_name
  location            = var.location
  firewall_name       = "afw-hub-${var.environment}"
  subnet_id           = module.hub.hub_subnet_ids["AzureFirewallSubnet"]
  sku_tier            = "Standard"
  tags                = var.tags
}

# 3. Azure Bastion Module in Hub
module "azure_bastion" {
  source = "../../modules/azure_bastion"

  resource_group_name = module.hub.resource_group_name
  location            = var.location
  bastion_name        = "bas-hub-${var.environment}"
  subnet_id           = module.hub.hub_subnet_ids["AzureBastionSubnet"]
  sku                 = "Standard"
  tags                = var.tags
}

# 4. Spoke Networks Module (AKS Spoke + Data Spoke) with default routing to Firewall
module "spokes" {
  source = "../../modules/spoke_network"

  resource_group_name = locals.spoke_rg_name
  location            = var.location
  firewall_private_ip = module.azure_firewall.firewall_private_ip
  spoke_vnets         = var.spoke_vnets
  tags                = var.tags
}

# 5. Bidirectional VNet Peering Module (Hub <-> Spokes)
module "vnet_peering" {
  source = "../../modules/vnet_peering"

  hub_vnet_name = module.hub.hub_vnet_name
  hub_rg_name   = module.hub.resource_group_name
  hub_vnet_id   = module.hub.hub_vnet_id

  spokes_map = {
    for k, v in module.spokes.spoke_vnet_ids : k => {
      id                  = v
      name                = module.spokes.spoke_vnet_names[k]
      resource_group_name = locals.spoke_rg_name
    }
  }

  depends_on = [module.hub, module.spokes]
}

# 6. Private DNS Zones Module
module "private_dns" {
  source = "../../modules/private_dns"

  resource_group_name = module.hub.resource_group_name
  dns_zones           = var.dns_zones
  vnet_links = merge(
    { "hub" = { vnet_id = module.hub.hub_vnet_id, registration_enabled = false } },
    { for k, v in module.spokes.spoke_vnet_ids : k => { vnet_id = v, registration_enabled = false } }
  )
  tags = var.tags
}
