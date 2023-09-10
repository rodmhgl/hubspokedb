locals {
  address_spaces                      = zipmap(var.regions, var.address_spaces)
  monitoring_workspace_name           = "${var.prefix}-${var.environment}-azmonitor-${var.regions[0]}-log"
  monitoring_event_hub_namespace_name = "${var.prefix}-${var.environment}-azmonitor-${var.regions[0]}-ehn"
  # monitoring_event_hub_name           = "${var.prefix}-${var.environment}-azmonitor-${var.regions[0]}-evh"
  monitoring_resource_group_name = "${var.prefix}-${var.environment}-azmonitor-${var.regions[0]}-rg"

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
      #flow_timeout_in_minutes          = 4
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

data "azurerm_log_analytics_workspace" "monitoring" {
  name                = local.monitoring_workspace_name
  resource_group_name = local.monitoring_resource_group_name
}

# data "azurerm_eventhub" "monitoring" {
#   name                = local.monitoring_event_hub_name
#   resource_group_name = local.monitoring_resource_group_name
#   namespace_name      = local.monitoring_event_hub_namespace_name
# }

data "azurerm_resources" "monitoring" {
  type                = "Microsoft.Storage/storageAccounts"
  resource_group_name = local.monitoring_resource_group_name
  required_tags = {
    "role" = "diagnostics"
  }
}

data "azurerm_storage_account" "monitoring" {
  name                = data.azurerm_resources.monitoring.resources[0].name
  resource_group_name = local.monitoring_resource_group_name
}

# data "azurerm_monitor_diagnostic_categories" "firewalls" {
#   for_each    = module.hubnetworks.firewalls
#   resource_id = each.value.id
# }

locals {
  diagnostics_map = {
    diags_sa = data.azurerm_storage_account.monitoring.id
    eh_id    = data.azurerm_eventhub_namespace.monitoring.id
    eh_name  = data.azurerm_eventhub_namespace.monitoring.name
  }
}

data "azurerm_eventhub_namespace" "monitoring" {
  name                = local.monitoring_event_hub_namespace_name
  resource_group_name = local.monitoring_resource_group_name
}

data "azurerm_monitor_diagnostic_categories" "virtual_networks" {
  for_each    = module.hubnetworks.virtual_networks
  resource_id = each.value.id
}

module "virtual_network_diagnostics" {
  for_each = module.hubnetworks.virtual_networks

  source        = "github.com/rodmhgl/terraform-azurerm-azuremonitoronboarding?ref=v1.0.1"
  resource_name = each.value.name
  resource_id   = each.value.id
  diagnostics_logs_map = {
    log    = [for log in data.azurerm_monitor_diagnostic_categories.virtual_networks[each.key].log_category_types : [log, true, 30]],
    metric = [for metric in data.azurerm_monitor_diagnostic_categories.virtual_networks[each.key].metrics : [metric, true, 30]],
  }
  diagnostics_map                   = local.diagnostics_map
  log_analytics_workspace_dedicated = "Dedicated"
  log_analytics_workspace_id        = data.azurerm_log_analytics_workspace.monitoring.id
}
