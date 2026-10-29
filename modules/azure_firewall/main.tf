resource "azurerm_public_ip" "fw_pip" {
  name                = "${var.firewall_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall_policy" "fw_policy" {
  name                = "${var.firewall_name}-policy"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku_tier
  tags                = var.tags

  dns {
    proxy_enabled = true
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "network_rules" {
  name               = "NetworkRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 200

  network_rule_collection {
    name     = "CoreInfrastructureRules"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "Allow-DNS"
      protocols             = ["UDP", "TCP"]
      source_addresses      = ["10.0.0.0/8"]
      destination_addresses = ["*"]
      destination_ports     = ["53"]
    }

    rule {
      name                  = "Allow-NTP"
      protocols             = ["UDP"]
      source_addresses      = ["10.0.0.0/8"]
      destination_addresses = ["*"]
      destination_ports     = ["123"]
    }

    rule {
      name                  = "Allow-Internal-East-West"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["10.1.0.0/16"]
      destination_addresses = ["10.2.0.0/16"]
      destination_ports     = ["80", "443", "3306", "27017"]
    }
  }

  application_rule_collection {
    name     = "OutboundWebRules"
    priority = 200
    action   = "Allow"

    rule {
      name                  = "Allow-HTTPS-Package-Mirrors"
      source_addresses      = ["10.0.0.0/8"]
      destination_fqdns     = [
        "*.ubuntu.com",
        "*.microsoft.com",
        "*.github.com",
        "*.docker.com",
        "*.azurecr.io"
      ]

      protocols {
        type = "Https"
        port = 443
      }
    }
  }
}

resource "azurerm_firewall" "firewall" {
  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id
  tags                = var.tags

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }
}
