## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.67.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.67.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hubnetworks"></a> [hubnetworks](#module\_hubnetworks) | Azure/hubnetworking/azurerm | 0.2.0 |
| <a name="module_naming"></a> [naming](#module\_naming) | Azure/naming/azurerm | 0.3.0 |
| <a name="module_naming_firewall_policy"></a> [naming\_firewall\_policy](#module\_naming\_firewall\_policy) | Azure/naming/azurerm | 0.3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall_policy.fwpolicy](https://registry.terraform.io/providers/hashicorp/azurerm/3.67.0/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy_rule_collection_group.allow_internal](https://registry.terraform.io/providers/hashicorp/azurerm/3.67.0/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_resource_group.fwpolicy](https://registry.terraform.io/providers/hashicorp/azurerm/3.67.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.hub_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.67.0/docs/resources/resource_group) | resource |
| [random_pet.rand](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/pet) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_virtual_networks"></a> [virtual\_networks](#output\_virtual\_networks) | n/a |
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.67.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.67.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hubnetworks"></a> [hubnetworks](#module\_hubnetworks) | Azure/hubnetworking/azurerm | 0.2.0 |
| <a name="module_naming"></a> [naming](#module\_naming) | Azure/naming/azurerm | 0.3.0 |
| <a name="module_naming_firewall_policy"></a> [naming\_firewall\_policy](#module\_naming\_firewall\_policy) | Azure/naming/azurerm | 0.3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall_policy.fwpolicy](https://registry.terraform.io/providers/hashicorp/azurerm/3.67.0/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy_rule_collection_group.allow_internal](https://registry.terraform.io/providers/hashicorp/azurerm/3.67.0/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_resource_group.fwpolicy](https://registry.terraform.io/providers/hashicorp/azurerm/3.67.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.hub_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.67.0/docs/resources/resource_group) | resource |
| [random_pet.rand](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/pet) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_virtual_networks"></a> [virtual\_networks](#output\_virtual\_networks) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
