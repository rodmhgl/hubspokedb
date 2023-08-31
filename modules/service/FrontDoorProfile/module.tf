resource "azurerm_cdn_frontdoor_profile" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name #azurerm_resource_group.this.name
  sku_name                 = var.sku_name            # "Standard_AzureFrontDoor"
  response_timeout_seconds = var.response_timeout_seconds
  tags                     = var.tags
}
