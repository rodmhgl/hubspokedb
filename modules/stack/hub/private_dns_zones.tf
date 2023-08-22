resource "azurerm_resource_group" "private_dns" {
  location = local.regions[0]
  name     = module.naming["eastus"].private_dns_zone.name
  tags     = local.tags
}

variable "private_dns_zones" {
  type = map(object({}))
  default = {
    "privatelink.blob.core.windows.net" = {}
    # "privatelink.table.core.windows.net"        = {}
    # "privatelink.queue.core.windows.net"        = {}
    # "privatelink.file.core.windows.net"         = {}
    # "privatelink.web.core.windows.net"          = {}
    # "privatelink.documents.azure.com"           = {}
    # "privatelink.mongo.cosmos.azure.com"        = {}
    # "privatelink.cassandra.cosmos.azure.com"    = {}
    # "privatelink.gremlin.cosmos.azure.com"      = {}
    # "privatelink.table.cosmos.azure.com"        = {}
    # "privatelink.vaultcore.azure.net"           = {}
    # "privatelink.managedhsm.azure.net"          = {}
    # "privatelink.azurecr.io"                    = {}
    # "privatelink.siterecovery.windowsazure.com" = {}
    # "privatelink.servicebus.windows.net"        = {}
    # "privatelink.monitor.azure.com"             = {}
    # "privatelink.eastus.azmk8s.io"              = {}
    # "privatelink.eastus2.azmk8s.io"             = {}
    # "privatelink.eus.backup.windowsazure.com"   = {}
    # "privatelink.eus2.backup.windowsazure.com"  = {}
  }
}

module "private_dns_zones" {
  source = "../../service/PrivateDNSZone"
  # version = ""
  for_each = var.private_dns_zones

  name                = each.key
  resource_group_name = azurerm_resource_group.private_dns.name
  virtual_network_ids = local.dns_virtual_networks_ids
  tags                = local.tags
}
