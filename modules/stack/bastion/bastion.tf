locals {
  hub_virtual_network_names = {
    for r in local.regions : r => ({
      name                = "${var.prefix}-${var.environment}-hub-${r}-fw"
      resource_group_name = "${var.prefix}-${var.environment}-hub-${r}-rg"
    })
  }
}

data "azurerm_virtual_network" "hub" {
  for_each            = local.regions
  name                = local.hub_virtual_network_names[each.value].name
  resource_group_name = local.hub_virtual_network_names[each.value].resource_group_name
}

data "azurerm_subnet" "bastion" {
  for_each = local.regions

  name                 = "AzureBastionSubnet"
  virtual_network_name = data.azurerm_virtual_network.hub[each.value].name
  resource_group_name  = data.azurerm_virtual_network.hub[each.value].resource_group_name
}

module "bastion_host" {
  # source   = "github.com/rodmhgl/terraform-azurerm-bastionhost?ref=v2.2.0"
  source   = "rodmhgl/bastionhost/azurerm"
  version  = "2.2.0"
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
