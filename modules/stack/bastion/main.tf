locals {
  regions = toset(var.regions)

  mandatory_tags = {
    environment = var.environment
    stack       = "bastion"
  }

  tags = merge(var.tags, local.mandatory_tags)
}

module "naming" {
  for_each = local.regions

  source  = "Azure/naming/azurerm"
  version = "0.3.0"
  prefix  = [lower(var.prefix), lower(var.environment), "bastion", each.value]
}

resource "azurerm_resource_group" "this" {
  for_each = local.regions

  location = each.value
  name     = module.naming[each.value].resource_group.name
  tags     = local.tags
}
