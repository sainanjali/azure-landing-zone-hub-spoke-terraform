environment = "dev"
location    = "eastus2"

hub_vnet_name     = "vnet-hub-dev-eastus2"
hub_address_space = ["10.0.0.0/16"]

hub_subnets = {
  "AzureFirewallSubnet" = {
    address_prefixes = ["10.0.1.0/26"]
  }
  "AzureBastionSubnet" = {
    address_prefixes = ["10.0.2.0/26"]
  }
  "GatewaySubnet" = {
    address_prefixes = ["10.0.3.0/27"]
  }
  "snet-hub-management" = {
    address_prefixes                          = ["10.0.4.0/24"]
    private_endpoint_network_policies_enabled = true
  }
}

spoke_vnets = {
  "vnet-spoke-aks-dev" = {
    address_space = ["10.1.0.0/16"]
    subnets = {
      "snet-aks-system-nodes" = {
        address_prefixes = ["10.1.0.0/22"]
      }
      "snet-aks-user-workloads" = {
        address_prefixes = ["10.1.4.0/22"]
      }
      "snet-ingress-appgw" = {
        address_prefixes = ["10.1.8.0/24"]
      }
    }
  }

  "vnet-spoke-data-dev" = {
    address_space = ["10.2.0.0/16"]
    subnets = {
      "snet-private-endpoints" = {
        address_prefixes  = ["10.2.1.0/24"]
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
      }
      "snet-databases" = {
        address_prefixes  = ["10.2.2.0/24"]
        service_endpoints = ["Microsoft.Sql"]
      }
    }
  }
}

tags = {
  Environment        = "Development"
  Architecture       = "Hub-and-Spoke"
  Framework          = "Cloud-Adoption-Framework-CAF"
  IaC_Tool           = "Terraform"
  CostCenter         = "Cloud-Engineering"
  Author             = "Anjali Sain"
}
