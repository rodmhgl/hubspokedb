locals {
  regions = toset(["eastus", "eastus2"])
}

resource "random_pet" "rand" {}

resource "azurerm_resource_group" "hub_rg" {
  for_each = local.regions

  location = each.value
  name     = module.naming[each.value].resource_group.name
}

module "naming" {
  for_each = local.regions

  source  = "Azure/naming/azurerm"
  version = "0.3.0"
  prefix  = ["dbdemo", each.value]
}

output "virtual_networks" {
  value = module.hubnetworks.virtual_networks
}

module "hubnetworks" {
  source  = "Azure/hubnetworking/azurerm"
  version = "0.2.0"

  hub_virtual_networks = {
    eastus = {
      name                            = module.naming["eastus"].firewall.name
      address_space                   = ["10.0.0.0/16"]
      location                        = azurerm_resource_group.hub_rg["eastus"].location
      resource_group_name             = azurerm_resource_group.hub_rg["eastus"].name
      resource_group_creation_enabled = false
      resource_group_lock_enabled     = false
      mesh_peering_enabled            = true
      routing_address_space           = ["10.0.0.0/16"]
      firewall = {
        sku_name              = "AZFW_VNet"
        sku_tier              = "Standard"
        subnet_address_prefix = "10.0.1.0/24"
        threat_intel_mode     = "Off"
        firewall_policy_id    = azurerm_firewall_policy.fwpolicy.id
      }
    }
    eastus2 = {
      name                            = module.naming["eastus2"].firewall.name
      address_space                   = ["10.1.0.0/16"]
      location                        = azurerm_resource_group.hub_rg["eastus2"].location
      resource_group_name             = azurerm_resource_group.hub_rg["eastus2"].name
      resource_group_creation_enabled = false
      resource_group_lock_enabled     = false
      mesh_peering_enabled            = true
      routing_address_space           = ["10.1.0.0/16"]
      firewall = {
        sku_name              = "AZFW_VNet"
        sku_tier              = "Standard"
        subnet_address_prefix = "10.1.1.0/24"
        threat_intel_mode     = "Off"
        firewall_policy_id    = azurerm_firewall_policy.fwpolicy.id
      }
    }
  }

  depends_on = [azurerm_firewall_policy_rule_collection_group.allow_internal]
}
