locals {
  regions          = ["eastus", "eastus2"]
  primary_region   = local.regions[0]
  secondary_region = local.regions[1]
  address_spaces = {
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
    eastus  = { address_space = local.address_spaces.eastus[var.environment] }
    eastus2 = { address_space = local.address_spaces.eastus2[var.environment] }
  }
  tags = {
    environment = var.environment
    module      = path.root
  }
  # tags = merge(local.module_tags, var.tags)
  dns_virtual_networks_ids = [
    for r in local.regions : ({
      id                   = module.hubnetworks.virtual_networks[r].id,
      registration_enabled = false
    })
  ]
}