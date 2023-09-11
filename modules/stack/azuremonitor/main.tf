locals {
  regions = toset(var.regions)
  mandatory_tags = {
    environment = var.environment
    role        = "diagnostics"
    stack       = "azuremonitor"
  }

  tags = merge(var.tags, local.mandatory_tags)
}

module "naming" {
  for_each = local.regions
  source   = "Azure/naming/azurerm"
  version  = "0.3.0"
  prefix   = [lower(var.prefix), lower(var.environment), "azmon", each.value]
}

resource "azurerm_resource_group" "this" {
  for_each = local.regions
  location = each.value
  name     = module.naming[each.value].resource_group.name
  tags     = local.tags
}

module "AzureMonitor" {
  for_each                     = local.regions
  source                       = "github.com/rodmhgl/terraform-azurerm-azuremonitor?ref=v2.0.2"
  log_analytics_workspace_name = module.naming[each.value].log_analytics_workspace.name
  location                     = azurerm_resource_group.this[each.value].location
  resource_group_name          = azurerm_resource_group.this[each.value].name
  tags                         = local.tags
  # log_analytics_workspace_sku = "PerGB2018"
  # log_analytics_workspace_retention = 30
  # log_analytics_workspace_daily_quota = -1
  # log_analytics_workspace_ingestion = true
  # log_analytics_workspace_query = true
  # log_analytics_workspace_reservation = null
  eventhub_required       = true
  eventhub_name           = module.naming[each.value].eventhub.name
  eventhub_namespace_name = module.naming[each.value].eventhub_namespace.name
  # eventhub_required = false
  # eventhub_sku = "Basic"
  # eventhug_partition_count= 4
  # eventhub_capacity = 2
  # eventhub_zone_redundant = false
  # eventhub_throughput = null
  # eventhub_dedicated_cluster = null
  # eventhub_message_retention = 1
  # eventhub_status = "Active"
  # eventhub_network_rules = {
  #   trusted_service_access_enabled = bool
  #   ip_rules                       = list(string)
  #   subnet_ids                     = list(string)
  # }
  storage_account_required = true
  storage_account_name     = module.naming[each.value].storage_account.name_unique
  # storage_account_required = false
  # storage_account_tier = "Standard"
  # storage_account_replication_type = "LRS"
  # storage_account_kind = "StorageV2"
  # storage_account_access_tier = "Cool"
}
