locals {
  regions = toset(data.terraform_remote_state.hub.outputs.hub_regions)

  landing_zone_state_key = "db/${lower(var.environment)}/hub_landing_zone.tfstate"

  mandatory_tags = {
    environment = var.environment
    module      = path.root
  }

  tags = merge(var.tags, local.mandatory_tags)
}

data "terraform_remote_state" "hub" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate6982"
    container_name       = "tfstate"
    key                  = local.landing_zone_state_key # "db/nonprod/hub_landing_zone.tfstate"
    subscription_id      = "2b94710c-f41d-430c-b0ef-c76e2667cae2"
  }
}

module "naming" {
  for_each = local.regions

  source  = "Azure/naming/azurerm"
  version = "0.3.0"
  prefix  = [lower(var.prefix), lower(var.environment), "temp-bastion", each.value]
}

resource "azurerm_resource_group" "this" {
  for_each = local.regions

  location = each.value
  name     = module.naming[each.value].resource_group.name
  tags     = local.tags
}

