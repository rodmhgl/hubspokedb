locals {
  hub_public_ip_prefixes = {
    for r in local.regions : r => ({
      name                = "${var.prefix}-${var.environment}-pips-${r}-pippf"
      resource_group_name = "${var.prefix}-${var.environment}-pips-${r}-rg"
    })
  }
}

data "azurerm_public_ip_prefix" "hub" {
  for_each            = local.regions
  name                = local.hub_public_ip_prefixes[each.value].name
  resource_group_name = local.hub_public_ip_prefixes[each.value].resource_group_name
}

resource "azurerm_public_ip" "bastion" {
  for_each = local.regions

  location                = each.value
  name                    = module.naming[each.value].public_ip.name
  resource_group_name     = azurerm_resource_group.this[each.value].name
  allocation_method       = "Static"
  sku                     = "Standard"
  public_ip_prefix_id     = data.azurerm_public_ip_prefix.hub[each.value].id # local.public_ip_prefixes[each.value].id
  idle_timeout_in_minutes = 4
}
