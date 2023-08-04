# insert a terraform block to configure the azurerm provider
terraform {
  required_version = ">=1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.67.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate6982"
    container_name       = "tfstate"
    key                  = "db/nonprod/hub_landing_zone.tfstate"
    # use_oidc             = true
    # use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
}