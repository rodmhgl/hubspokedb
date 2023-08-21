# insert a terraform block to configure the azurerm provider
terraform {
  required_version = ">=1.4.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.70.0"
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
    key                  = "db/nonprod/dev/storefront_landing_zone.tfstate"
    # use_oidc             = true
    # use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
}