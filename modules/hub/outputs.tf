output "hub_regions" {
  value = local.regions
}

output "hub_firewalls" {
  value = module.hubnetworks.firewalls
}

output "hub_networks" {
  value = module.hubnetworks.virtual_networks
}

output "hub_route_tables" {
  value = module.hubnetworks.hub_route_tables
}

output "hub_subnet_addressing" {
  value = module.subnet_addressing
}

output "base_firewall_policy_id" {
  value = azurerm_firewall_policy.fwpolicy.id
}

output "public_ip_prefixes" {
  value = azurerm_public_ip_prefix.this
}
