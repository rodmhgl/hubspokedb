# insert a terraform block to configure the azurerm provider
terraform {
  required_version = ">= 1.4.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }

}
