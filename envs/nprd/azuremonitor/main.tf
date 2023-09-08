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

variable "region" {
  type        = string
  description = "The region you are deploying to."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources."
}

output "azmonitor_out" {
  value = module.AzureMonitor
}

output "law_out" {
  value = module.AzureMonitor.law_out
}

output "sa_out" {
  value = module.AzureMonitor.sa_out
}

output "ehnamespace_out" {
  value = module.AzureMonitor.ehnamespace_out
}

output "eh_out" {
  value = module.AzureMonitor.eh_out
}

module "AzureMonitor" {
  source      = "../../../modules/stack/azuremonitor"
  prefix      = var.prefix
  environment = var.environment
  region      = var.region
  tags        = var.tags
}
