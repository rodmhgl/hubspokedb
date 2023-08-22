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
  prefix  = [lower(var.prefix), lower(var.environment), "bastion", each.value]
}

data "azurerm_subnet" "bastion" {
  for_each = local.regions

  name                 = "AzureBastionSubnet"
  virtual_network_name = local.virtual_networks[each.value].name
  resource_group_name  = local.virtual_networks[each.value].resource_group_name
}

resource "azurerm_resource_group" "this" {
  for_each = local.regions

  location = each.value
  name     = module.naming[each.value].resource_group.name
  tags     = local.tags
}

resource "azurerm_public_ip" "bastion" {
  for_each = local.regions

  location                = each.value
  name                    = module.naming[each.value].public_ip.name
  resource_group_name     = azurerm_resource_group.this[each.value].name
  allocation_method       = "Static"
  sku                     = "Standard"
  public_ip_prefix_id     = local.public_ip_prefixes[each.value].id #data.terraform_remote_state.hub.outputs.hub_public_ip_prefixes[each.value].id
  idle_timeout_in_minutes = 4
}

# resource "azurerm_bastion_host" "hub" {
#   for_each = toset(local.regions)

#   location               = each.value
#   name                   = module.naming[each.value].bastion_host.name
#   resource_group_name    = azurerm_resource_group.this[each.value].name
#   sku                    = "Standard"
#   copy_paste_enabled     = true
#   file_copy_enabled      = true
#   ip_connect_enabled     = true
#   shareable_link_enabled = true

#   ip_configuration {
#     name                 = "bastion-${each.value}-pip"
#     public_ip_address_id = azurerm_public_ip.bastion[each.value].id
#     subnet_id            = data.azurerm_subnet.bastion[each.value].id #azurerm_subnet.bastion[each.value].id
#   }

# }

module "bastion_host" {
  source = "../../service/BastionHost"
  # version = ""
  for_each = local.regions

  name                = module.naming[each.value].bastion_host.name
  location            = azurerm_resource_group.this[each.value].location
  resource_group_name = azurerm_resource_group.this[each.value].name
  tags                = local.tags
  sku                 = "Standard"
  copy_paste_enabled  = true
  file_copy_enabled   = true
  tunneling_enabled   = true
  ip_configuration = {
    name                 = "bastion-${each.value}-pip"
    subnet_id            = data.azurerm_subnet.bastion[each.value].id #azurerm_subnet.bastion[each.value].id
    public_ip_address_id = azurerm_public_ip.bastion[each.value].id
  }
}
