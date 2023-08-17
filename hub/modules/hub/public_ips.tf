resource "azurerm_resource_group" "this" {
  for_each = toset(local.regions)

  location = each.value
  name     = module.naming_public_ips[each.value].resource_group.name
  tags     = local.tags
}

resource "azurerm_public_ip_prefix" "this" {
  for_each = toset(local.regions)

  name                = module.naming_public_ips[each.value].public_ip_prefix.name
  location            = azurerm_resource_group.this[each.value].location
  resource_group_name = azurerm_resource_group.this[each.value].name
  prefix_length       = 31
  tags                = local.tags
}