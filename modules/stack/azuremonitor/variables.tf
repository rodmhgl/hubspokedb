variable "prefix" {
  type        = string
  description = "Prefix to be used for all resources in this example."
  default     = "dbdemo"
}

variable "environment" {
  type        = string
  description = "Environment to be used for all resources in this example."
  default     = "nprd"
}

variable "tags" {
  type        = map(string)
  description = "The tags to associate with your network security groups."
  default     = {}
}

variable "region" {
  type        = string
  description = "The region where the landing zone resources will be deployed."
  default     = "eastus"
}
