locals {
  regions = var.regions

  mandatory_tags = {
    environment = var.environment
    stack       = "frontdoor"
  }

  tags           = merge(var.tags, local.mandatory_tags)
  primary_region = local.regions[0]
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
  prefix  = [lower(var.prefix), lower(var.environment), "frontdoor", local.primary_region]
}

resource "azurerm_resource_group" "this" {
  name     = module.naming.resource_group.name
  location = local.primary_region
  tags     = local.tags
}

module "frontdoor_profile" {
  source              = "github.com/rodmhgl/FrontDoorProfile?ref=v1.0.0"
  name                = module.naming.frontdoor.name
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.tags
}
