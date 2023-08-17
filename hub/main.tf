terraform {
  required_version = ">=1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.67.0"
    }
    # random = {
    #   source  = "hashicorp/random"
    #   version = "3.5.1"
    # }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate6982"
    container_name       = "tfstate"
    # key                  = "db/nonprod/hub_landing_zone.tfstate"
    subscription_id = "2b94710c-f41d-430c-b0ef-c76e2667cae2"
    # use_oidc             = true
    # use_azuread_auth     = true
  }
}

variable "environment" {
  type        = string
  description = "The environment for the landing zone resources."
  default     = "nprd"
}

module "hub_network" {
  source      = "./modules/hub"
  environment = var.environment
  prefix      = "dbdemo"
}
