locals {
  regions = toset(["eastus", "eastus2"])
}

variable "subscription_id" {
  type = string
}

data "terraform_remote_state" "hub" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate6982"
    container_name       = "tfstate"
    key                  = "db/nonprod/hub_landing_zone.tfstate"
  }
}

module "naming_connectivity" {
  for_each = local.regions

  source  = "Azure/naming/azurerm"
  version = "0.3.0"
  prefix  = ["storefront", "connectivity", each.value]
}

resource "azurerm_resource_group" "storefront_rg" {
  for_each = local.regions

  location = each.value
  name     = module.naming_connectivity[each.value].resource_group.name #"hubandspokedemo-hub-${each.value}-${random_pet.rand.id}"
}

module "lz-vending" {
  source                                 = "Azure/lz-vending/azurerm"
  version                                = "3.4.1"
  location                               = "eastus"
  subscription_id                        = var.subscription_id
  network_watcher_resource_group_enabled = true
  virtual_network_enabled                = true
  virtual_networks = {
    eastus = {
      resource_group_name             = azurerm_resource_group.storefront_rg["eastus"].name #"rg-test-eastus"
      resource_group_creation_enabled = false
      name                            = "my-vnet"
      address_space                   = ["10.2.100.0/24"]
      hub_peering_enabled             = true
      hub_peering_use_remote_gateways = false
      hub_network_resource_id         = data.terraform_remote_state.hub.outputs.virtual_networks["eastus"].id #module.hubnetworks.virtual_networks["eastus-hub"].id
      mesh_peering_enabled            = true
    }
    eastus2 = {
      resource_group_name             = azurerm_resource_group.storefront_rg["eastus2"].name
      resource_group_creation_enabled = false
      name                            = "my-vnet2"
      location                        = "eastus2"
      address_space                   = ["10.2.101.0/24"]
      hub_peering_enabled             = true
      hub_peering_use_remote_gateways = false
      hub_network_resource_id         = data.terraform_remote_state.hub.outputs.virtual_networks["eastus2"].id #module.hubnetworks.virtual_networks["eastus2-hub"].id
      mesh_peering_enabled            = true
    }
  }
  subscription_register_resource_providers_enabled = true
}

resource "azurerm_subnet" "aks_nodes" {
  address_prefixes     = ["value"]
  name                 = "value"
  resource_group_name  = "value"
  virtual_network_name = "value"
}

# resource "azurerm_public_ip_prefix" "hub_prefix" {
#   for_each = local.regions
#   resource_group_name = data.azurerm_resource_group.resource_groups[each.value].name
#   location  = data.azurerm_resource_group.resource_groups[each.value].name
#   name      = module
# }