locals {
  address_spaces = zipmap(var.regions, var.address_spaces)

  # tflint-ignore: terraform_unused_declarations
  firewall_tags = merge(local.tags, {
    "role" = "hub_firewall"
  })
  network_tags = merge(local.tags, {
    "role" = "hub_virtual_network"
  })

  hub_virtual_networks = {
    for r in var.regions : r => {
      address_space                   = [local.address_spaces[r]]
      name                            = module.naming[r].firewall.name
      location                        = azurerm_resource_group.hub[r].location
      resource_group_name             = azurerm_resource_group.hub[r].name
      resource_group_creation_enabled = false
      resource_group_lock_enabled     = false
      mesh_peering_enabled            = true
      routing_address_space           = [local.address_spaces[r]]
      tags                            = local.network_tags
      hub_router_ip_address           = "1.2.3.4"
      subnets = {
        # The module will currently fail attempting to attach a route table to AzureBastionSubnet
        AzureBastionSubnet = {
          address_prefixes             = [module.subnet_addressing[r].network_cidr_blocks["AzureBastionSubnet"]]
          assign_generated_route_table = false
        }
        ServiceNowVMs = {
          address_prefixes = [module.subnet_addressing[r].network_cidr_blocks["ServiceNowVM"]]
        }
      }
      # firewall = {
      #   sku_name              = "AZFW_VNet"
      #   sku_tier              = "Standard"
      #   threat_intel_mode     = "Off"
      #   subnet_address_prefix = module.subnet_addressing[r].network_cidr_blocks["AzureFirewallSubnet"]
      #   firewall_policy_id    = azurerm_firewall_policy.fwpolicy.id
      #   tags                  = local.firewall_tags
      # }
    }
  }

}

resource "azurerm_resource_group" "hub" {
  for_each = toset(local.regions)

  location = each.value
  name     = module.naming[each.value].resource_group.name
  tags     = local.tags
}

module "subnet_addressing" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  for_each = local.address_spaces

  base_cidr_block = each.value
  networks = [
    {
      name     = "AzureFirewallSubnet"
      new_bits = 10
    },
    {
      name     = "AzureBastionSubnet"
      new_bits = 10
    },
    {
      name     = "ServiceNowVM"
      new_bits = 8
    },
  ]
}

module "hubnetworks" {
  source               = "Azure/hubnetworking/azurerm"
  version              = "1.1.0"
  hub_virtual_networks = local.hub_virtual_networks
  depends_on           = [azurerm_firewall_policy_rule_collection_group.allow_internal]
}
