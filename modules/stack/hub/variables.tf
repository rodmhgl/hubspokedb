variable "environment" {
  type        = string
  description = "The environment to deploy to. Valid values are sim, nprd, and prd."
  default     = "sim"

  validation {
    condition     = contains(["sim", "nprd", "prd"], var.environment)
    error_message = "The environment must be one of sim, nprd, or prd."
  }
}

variable "prefix" {
  type        = string
  description = "The prefix to use for all resources in this deployment."
  default     = "dbdemo"
}
variable "tags" {
  type        = map(string)
  description = "The tags to associate with your network security groups."
  default     = {}
}

variable "regions" {
  type        = list(string)
  description = "The list of regions where the landing zone resources will be deployed."
  default     = ["eastus", "eastus2", ]
}