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