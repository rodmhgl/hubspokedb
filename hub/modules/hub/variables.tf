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