locals {
  regions          = var.regions
  primary_region   = local.regions[0]
  secondary_region = local.regions[1]

  address_spaces = { # environments is validated to ensure a valid space here
    eastus = {
      sim  = "10.1.0.0/16"
      nprd = "10.1.0.0/16"
      prd  = "10.1.0.0/16"
    }
    eastus2 = {
      sim  = "10.2.0.0/16"
      nprd = "10.2.0.0/16"
      prd  = "10.2.0.0/16"
    }
  }

  address_space = {
    for region, spaces in local.address_spaces : region => {
      address_space = spaces[var.environment]
    }
  }

  module_tags = {
    environment = var.environment
    stack       = "hub"
  }

  tags = merge(local.module_tags, var.tags)

  dns_virtual_networks_ids = [
    for r in local.regions : ({
      id                   = module.hubnetworks.virtual_networks[r].id,
      registration_enabled = false
    })
  ]
}