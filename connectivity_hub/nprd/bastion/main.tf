locals {
  regions = toset(data.terraform_remote_state.hub.outputs.hub_regions)

  virtual_networks = {
    for r in local.regions : r => ({
      name                = data.terraform_remote_state.hub.outputs.hub_networks[r].name,
      resource_group_name = data.terraform_remote_state.hub.outputs.hub_networks[r].resource_group_name,
      address_prefix      = data.terraform_remote_state.hub.outputs.hub_subnet_addressing[r].network_cidr_blocks["AzureBastionSubnet"]
    })
  }

  public_ip_prefixes = {
    for r in local.regions : r => ({
      id = data.terraform_remote_state.hub.outputs.hub_public_ip_prefixes[r].id
    })
  }

  tags = {
    # environment = var.environment
    module = path.root
  }

  landing_zone_state_key = "db/${lower(var.environment)}/hub_landing_zone.tfstate"
}

data "terraform_remote_state" "hub" {
  backend = "azurerm"
  config = {
    #TODO: Parameterize this
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate6982"
    container_name       = "tfstate"
    key                  = local.landing_zone_state_key # "db/nonprod/hub_landing_zone.tfstate"
    subscription_id      = "2b94710c-f41d-430c-b0ef-c76e2667cae2"
  }
}

# module "bastion" {
#   # for_each = local.regions

#   source = "../../modules/bastion"
#   # version = ""
#   virtual_networks   = local.virtual_networks[each.key]
#   regions            = each.key
#   public_ip_prefixes = local.public_ip_prefixes[each.key]
# }

module "bastion_set" {
  source = "../../../modules/bastion"
  # version = ""
  environment        = var.environment
  virtual_networks   = local.virtual_networks
  regions            = local.regions
  public_ip_prefixes = local.public_ip_prefixes
  tags               = local.tags
}