output "hub_regions" {
  value = module.hub_network.hub_regions
}

output "hub_firewalls" {
  value = module.hub_network.hub_firewalls
}

output "hub_networks" {
  value = module.hub_network.hub_networks
}

output "hub_route_tables" {
  value = module.hub_network.hub_route_tables
}

output "hub_subnet_addressing" {
  value = module.hub_network.hub_subnet_addressing
}

output "hub_base_firewall_policy_id" {
  value = module.hub_network.base_firewall_policy_id
}

output "hub_public_ip_prefixes" {
  value = module.hub_network.public_ip_prefixes
}