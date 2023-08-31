variable "name" {
  type        = string
  description = "The name of the Front Door Profile."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Front Door Profile."
}

variable "sku_name" {
  type        = string
  description = "The name of the SKU used for this Front Door Profile."
  default     = "Standard_AzureFrontDoor"

  validation {
    condition     = contains(["Standard_AzureFrontDoor", "Premium_AzureFrontDoor", ], var.sku_name)
    error_message = "The sku must be Standard_AzureFrontDoor or Premium_AzureFrontDoor."
  }

}

variable "response_timeout_seconds" {
  type        = number
  description = "The maximum response timeout in seconds (16-240). Defaults to 120."
  default     = 120

  validation {
    condition     = var.response_timeout_seconds >= 16 && var.response_timeout_seconds <= 240
    error_message = "The response_timeout_seconds must be between 16 and 240 (inclusive)."
  }
}

variable "tags" {
  description = "(Required) map of tags for the deployment"
  type        = map(any)
}
