## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.4.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.70.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion_host"></a> [bastion\_host](#module\_bastion\_host) | ./BastionHost | n/a |
| <a name="module_naming"></a> [naming](#module\_naming) | Azure/naming/azurerm | 0.3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_public_ip.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment to be used for all resources in this example. | `string` | `"nprd"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix to be used for all resources in this example. | `string` | `"dbdemo"` | no |
| <a name="input_public_ip_prefixes"></a> [public\_ip\_prefixes](#input\_public\_ip\_prefixes) | The ID of the public ip prefix to use. | <pre>map(object({<br>    id = string<br>  }))</pre> | n/a | yes |
| <a name="input_regions"></a> [regions](#input\_regions) | The list of regions where the landing zone resources will be deployed. | `list(string)` | <pre>[<br>  "eastus",<br>  "eastus2"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to associate with your network security groups. | `map(string)` | `{}` | no |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | The virtual networks where the landing zone resources will be deployed. | <pre>map(object({<br>    name                = string<br>    resource_group_name = string<br>    address_prefix      = string<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_out"></a> [bastion\_out](#output\_bastion\_out) | n/a |
