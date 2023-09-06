terraform {
  required_version = ">= 1.5.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = var.purge_soft_delete_on_destroy
    }
  }
}
