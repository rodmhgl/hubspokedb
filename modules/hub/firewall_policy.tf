module "naming_firewall_policy" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
  prefix  = ["allow-internal", ]
}

resource "azurerm_resource_group" "fwpolicy" {
  location = local.regions[0]
  name     = module.naming["eastus"].firewall_policy.name #"fwpolicy-${random_pet.rand.id}"
  tags     = local.tags
}

resource "azurerm_firewall_policy" "fwpolicy" {
  sku                 = "Standard"
  name                = module.naming_firewall_policy.firewall_policy.name
  location            = azurerm_resource_group.fwpolicy.location
  resource_group_name = azurerm_resource_group.fwpolicy.name
  tags                = local.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "allow_internal" {
  firewall_policy_id = azurerm_firewall_policy.fwpolicy.id
  name               = module.naming_firewall_policy.firewall_policy_rule_collection_group.name
  priority           = 100

  network_rule_collection {
    action   = "Allow"
    name     = module.naming_firewall_policy.firewall_network_rule_collection.name
    priority = 100

    rule {
      destination_ports     = ["*"]
      name                  = "rfc1918"
      protocols             = ["Any"]
      destination_addresses = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
      source_addresses      = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    }
  }
}