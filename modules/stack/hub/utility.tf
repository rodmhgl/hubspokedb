module "naming" {
  for_each = toset(local.regions)

  source  = "Azure/naming/azurerm"
  version = "0.3.0"
  prefix  = [lower(var.prefix), lower(var.environment), "hub", each.value]
}

module "subnet_addressing" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  for_each = local.address_space

  base_cidr_block = each.value.address_space
  networks = [
    {
      name     = "AzureFirewallSubnet"
      new_bits = 10
    },
    {
      name     = "AzureBastionSubnet"
      new_bits = 10
    },
    {
      name     = "ServiceNowVM"
      new_bits = 8
    },
  ]
}