## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.4.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.70.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion_set"></a> [bastion\_set](#module\_bastion\_set) | ../../../modules/bastion | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.hub](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for the landing zone resources. | `string` | `"nprd"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_set"></a> [bastion\_set](#output\_bastion\_set) | n/a |
