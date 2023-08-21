module "hub_network" {
  # version     = ""
  source      = "../../../modules/hub"
  environment = var.environment
  prefix      = "dbdemo"
}

import {
  id = "/subscriptions/1b7aafc3-bd23-4dda-8b40-914c33ce962f/resourceGroups/dbdemo-nprd-hub-eastus-afwp"
  to = module.hub_network.azurerm_resource_group.fwpolicy
}

import {
  id = "/subscriptions/1b7aafc3-bd23-4dda-8b40-914c33ce962f/resourceGroups/dbdemo-nprd-hub-eastus2-rg"
  to = module.hub_network.azurerm_resource_group.hub_rg["eastus2"]
}

import {
  id = "/subscriptions/1b7aafc3-bd23-4dda-8b40-914c33ce962f/resourceGroups/dbdemo-nprd-hub-eastus-rg"
  to = module.hub_network.azurerm_resource_group.hub_rg["eastus"]
}

