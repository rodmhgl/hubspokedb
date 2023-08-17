# hub

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.67.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hub_network"></a> [hub\_network](#module\_hub\_network) | ./modules/hub | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for the landing zone resources. | `string` | `"nprd"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hub_base_firewall_policy_id"></a> [hub\_base\_firewall\_policy\_id](#output\_hub\_base\_firewall\_policy\_id) | n/a |
| <a name="output_hub_firewalls"></a> [hub\_firewalls](#output\_hub\_firewalls) | n/a |
| <a name="output_hub_networks"></a> [hub\_networks](#output\_hub\_networks) | n/a |
| <a name="output_hub_public_ip_prefixes"></a> [hub\_public\_ip\_prefixes](#output\_hub\_public\_ip\_prefixes) | n/a |
| <a name="output_hub_route_tables"></a> [hub\_route\_tables](#output\_hub\_route\_tables) | n/a |
| <a name="output_hub_subnet_addressing"></a> [hub\_subnet\_addressing](#output\_hub\_subnet\_addressing) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
