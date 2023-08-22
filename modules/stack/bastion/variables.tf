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

# variable "regions" {
#   type        = list(string)
#   description = "The list of regions where the landing zone resources will be deployed."
#   default     = ["eastus", "eastus2", ]
# }

# variable "virtual_networks" {
#   type = map(object({
#     name                = string
#     resource_group_name = string
#     address_prefix      = string
#   }))
#   description = "The virtual networks where the landing zone resources will be deployed."
# }

# variable "public_ip_prefixes" {
#   type = map(object({
#     id = string
#   }))
#   description = "The ID of the public ip prefix to use."
# }