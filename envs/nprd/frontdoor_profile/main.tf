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

variable "regions" {
  type        = list(string)
  description = "A list of the region(s) you are deploying to."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources."
  default     = {}
}

module "frontdoor" {
  source = "../../../modules/stack/frontdoor_profile"
  # version = ""
  prefix      = var.prefix
  environment = var.environment
  regions     = var.regions
  tags        = var.tags
}
