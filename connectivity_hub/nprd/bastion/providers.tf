terraform {
  required_version = ">=1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.70.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate6982"
    container_name       = "tfstate"
    subscription_id      = "2b94710c-f41d-430c-b0ef-c76e2667cae2"
    # key                  = "db/nonprod/hub_landing_zone.tfstate"
    # use_oidc             = true
    # use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
}