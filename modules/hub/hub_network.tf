resource "azurerm_resource_group" "hub" {
  for_each = toset(local.regions)

  location = each.value
  name     = module.naming[each.value].resource_group.name
  tags     = local.tags
}

module "hubnetworks" {
  source  = "Azure/hubnetworking/azurerm"
  version = "1.1.0"
  hub_virtual_networks = {
    eastus = {
      address_space                   = [local.address_space[local.primary_region].address_space]
      name                            = module.naming[local.primary_region].firewall.name
      location                        = azurerm_resource_group.hub[local.primary_region].location
      resource_group_name             = azurerm_resource_group.hub[local.primary_region].name
      resource_group_creation_enabled = false
      resource_group_lock_enabled     = false
      mesh_peering_enabled            = true
      routing_address_space           = [local.address_space[local.primary_region].address_space]
      tags                            = local.tags
      hub_router_ip_address           = "1.2.3.4"
      subnets = {
        # The module will currently fail attempting to attach a route table to AzureBastionSubnet
        AzureBastionSubnet = {
          address_prefixes             = [module.subnet_addressing[local.primary_region].network_cidr_blocks["AzureBastionSubnet"]]
          assign_generated_route_table = false
        }
        ServiceNowVMs = {
          address_prefixes = [module.subnet_addressing[local.primary_region].network_cidr_blocks["ServiceNowVM"]]
        }
      }
      # firewall = {
      #   sku_name              = "AZFW_VNet"
      #   sku_tier              = "Standard"
      #   threat_intel_mode     = "Off"
      #   subnet_address_prefix = module.subnet_addressing[local.primary_region].network_cidr_blocks["AzureFirewallSubnet"]
      #   firewall_policy_id    = azurerm_firewall_policy.fwpolicy.id
      #   tags                  = local.tags
      # }
    }
    eastus2 = {
      address_space                   = [local.address_space[local.secondary_region].address_space]
      name                            = module.naming[local.secondary_region].firewall.name
      location                        = azurerm_resource_group.hub[local.secondary_region].location
      resource_group_name             = azurerm_resource_group.hub[local.secondary_region].name
      resource_group_creation_enabled = false
      resource_group_lock_enabled     = false
      mesh_peering_enabled            = true
      routing_address_space           = [local.address_space[local.secondary_region].address_space]
      tags                            = local.tags
      hub_router_ip_address           = "1.2.3.4"
      subnets = {
        # The module will currently fail attempting to attach a route table to AzureBastionSubnet
        AzureBastionSubnet = {
          address_prefixes             = [module.subnet_addressing[local.secondary_region].network_cidr_blocks["AzureBastionSubnet"]]
          assign_generated_route_table = false
        }
        ServiceNowVMs = {
          address_prefixes = [module.subnet_addressing[local.secondary_region].network_cidr_blocks["ServiceNowVM"]]
        }
      }
      # firewall = {
      #   sku_name              = "AZFW_VNet"
      #   sku_tier              = "Standard"
      #   threat_intel_mode     = "Off"
      #   subnet_address_prefix = module.subnet_addressing[local.secondary_region].network_cidr_blocks["AzureFirewallSubnet"]
      #   firewall_policy_id    = azurerm_firewall_policy.fwpolicy.id
      #   tags                  = local.tags
      # }
    }
  }

  depends_on = [azurerm_firewall_policy_rule_collection_group.allow_internal]
}
