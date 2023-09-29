terraform {
  required_version = ">= 1.5.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71.0"
    }
  }

  backend "azurerm" {}

}

provider "azurerm" {
  features {}
}

variable "prefix" {
  type        = string
  description = "The prefix used for the naming convention."
}

variable "environment" {
  type        = string
  description = "The environment you are deploying to."
}

variable "address_spaces" {
  type        = list(string)
  description = "The address spaces to use for each region."
}

variable "regions" {
  type        = list(string)
  description = "A list of the region(s) you are deploying to."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources."
  default     = {}
}

output "hub_regions" {
  value = module.hub.hub_regions
}

output "hub_firewalls" {
  value = module.hub.hub_firewalls
}

output "hub_networks" {
  value = module.hub.hub_networks
}

output "hub_route_tables" {
  value = module.hub.hub_route_tables
}

output "hub_subnet_addressing" {
  value = module.hub.hub_subnet_addressing
}

output "hub_base_firewall_policy_id" {
  value = module.hub.hub_base_firewall_policy_id
}

output "hub_public_ip_prefixes" {
  value = module.hub.hub_public_ip_prefixes
}

output "hub_private_dns_zones" {
  value = module.hub.hub_private_dns_zones
}

output "diagnostics_stack" {
  value = module.hub.diag_helper.diagnostics_stack
}

module "hub" {
  source = "github.com/rodmhgl/terraform-azurerm-hub_stack?ref=v0.0.3"
  # source = "../../../modules/stack/hub"
  # version = ""
  prefix         = var.prefix
  environment    = var.environment
  regions        = var.regions
  address_spaces = var.address_spaces
  tags           = var.tags
}
