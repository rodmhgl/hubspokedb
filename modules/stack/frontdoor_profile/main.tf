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
  source              = "../../service/FrontDoorProfile"
  name                = module.naming.frontdoor.name
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.tags
}

resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = module.naming.frontdoor.name
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "Standard_AzureFrontDoor"
  # Maximum response timeout in seconds.
  # Possible values 16-240 (inclusive).
  # Defaults to 120.
  response_timeout_seconds = 120
  tags                     = local.tags
}
