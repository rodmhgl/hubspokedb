locals {
  # regions = var.regions

  # virtual_networks = {
  #   for r in var.regions : r => ({
  #     name                = data.terraform_remote_state.hub.outputs.hub_networks[r].name,
  #     resource_group_name = data.terraform_remote_state.hub.outputs.hub_networks[r].resource_group_name,
  #     address_prefix      = data.terraform_remote_state.hub.outputs.hub_subnet_addressing[r].network_cidr_blocks["AzureBastionSubnet"]
  #   })
  # }

  # public_ip_prefix = {
  #   for r in var.regions : r => ({
  #     id = data.terraform_remote_state.hub.outputs.hub_public_ip_prefixes[r].id
  #   })
  # }

  # landing_zone_state_key = "db/${lower(var.environment)}/hub_landing_zone.tfstate"

  mandatory_tags = {
    environment = var.environment
    module      = path.root
  }

  tags = merge(var.tags, local.mandatory_tags)
}

module "naming" {
  for_each = toset(var.regions)

  source  = "Azure/naming/azurerm"
  version = "0.3.0"
  prefix  = [lower(var.prefix), lower(var.environment), "bastion", each.value]
}

data "azurerm_subnet" "bastion" {
  for_each = toset(var.regions)

  name                 = "AzureBastionSubnet"
  virtual_network_name = var.virtual_networks[each.value].name
  resource_group_name  = var.virtual_networks[each.value].resource_group_name
}

resource "azurerm_resource_group" "this" {
  for_each = toset(var.regions)

  location = each.value
  name     = module.naming[each.value].resource_group.name
  tags     = local.tags
}

resource "azurerm_public_ip" "bastion" {
  for_each = toset(var.regions)

  location                = each.value
  name                    = module.naming[each.value].public_ip.name
  resource_group_name     = azurerm_resource_group.this[each.value].name
  allocation_method       = "Static"
  sku                     = "Standard"
  public_ip_prefix_id     = var.public_ip_prefixes[each.value].id #data.terraform_remote_state.hub.outputs.hub_public_ip_prefixes[each.value].id
  idle_timeout_in_minutes = 4
}

resource "azurerm_bastion_host" "hub" {
  for_each = toset(var.regions)

  location               = each.value
  name                   = module.naming[each.value].bastion_host.name
  resource_group_name    = azurerm_resource_group.this[each.value].name
  sku                    = "Standard"
  copy_paste_enabled     = true
  file_copy_enabled      = true
  ip_connect_enabled     = true
  shareable_link_enabled = true

  ip_configuration {
    name                 = "bastion-${each.value}-pip"
    public_ip_address_id = azurerm_public_ip.bastion[each.value].id
    subnet_id            = data.azurerm_subnet.bastion[each.value].id #azurerm_subnet.bastion[each.value].id
  }

}
