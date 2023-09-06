locals {
  mandatory_tags = {
    environment = var.environment
    stack       = "azuremonitor"
  }

  tags = merge(var.tags, local.mandatory_tags)
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
  prefix  = [lower(var.prefix), lower(var.environment), "azmonitor", var.region]
}

resource "azurerm_resource_group" "this" {
  location = var.region
  name     = module.naming.resource_group.name
  tags     = local.tags
}

module "AzureMonitor" {
  source                       = "github.com/rodmhgl/terraform-azurerm-azuremonitor?ref=v2.0.1"
  log_analytics_workspace_name = module.naming.log_analytics_workspace.name
  location                     = var.region
  resource_group_name          = azurerm_resource_group.this.name
  tags                         = local.tags
  # log_analytics_workspace_sku = "PerGB2018"
  # log_analytics_workspace_retention = 30
  # log_analytics_workspace_daily_quota = -1
  # log_analytics_workspace_ingestion = true
  # log_analytics_workspace_query = true
  # log_analytics_workspace_reservation = null
  eventhub_required       = true
  eventhub_name           = module.naming.eventhub.name
  eventhub_namespace_name = module.naming.eventhub_namespace.name
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
  storage_account_name     = module.naming.storage_account.name_unique
  # storage_account_required = false
  # storage_account_tier = "Standard"
  # storage_account_replication_type = "LRS"
  # storage_account_kind = "StorageV2"
  # storage_account_access_tier = "Cool"
}
