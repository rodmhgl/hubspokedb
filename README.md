# Hub Deployment Model

## Purpose

Simple demo of a non-monolithic / multi-region Terraform Azure hub deployment.

## Folder Structure

```
.
├── envs
│   ├── nprd
│   │   ├── azuremonitor
│   │   ├── bastion
│   │   ├── frontdoor_profile
│   │   └── hub
│   ├── prd
│   │   ├── bastion
│   │   ├── frontdoor_profile
│   │   └── hub
│   └── sim
│       ├── azuremonitor
│       ├── bastion
│       ├── frontdoor_profile
│       └── hub
└── modules
    ├── service
    │   └── KeyVault
    └── stack
        ├── azuremonitor
        ├── bastion
        ├── frontdoor_profile
        └── hub
            └── diag_helper
```

`envs` - Contains the environment-specific code. This is used to specify module versioning when calling the stack modules. It also contains the environment-specific variables in the form of a `base.tfvars` and `.auto.tfvars` files.

| :memo: NOTE              |
|:---------------------------|
| While currently present in this repo for ease of testing, stacks should be isolated into their own repositories for proper module versioning / testing. |

`modules/stack` - Contains the stack modules. A stack represents a collection of infrastructure that  Terraform synthesizes as a dedicated Terraform configuration. Stacks allow you to separate the state management for multiple environments within an application and allows for the use of different versions of modules for each environment.

`modules/service` - Contains the service modules. A service module is responsible for creating an infrastructure resource and may be shared across multiple stacks.

| :memo: NOTE              |
|:---------------------------|
| While currently present in this repo for ease of testing, service modules should be isolated into their own repositories for proper module versioning / testing. |

Environments are composed of a collection of root modules which calls the stack module. Environments are also responsible for creating the Terraform backend configuration and the Terraform state resources. The stack modules are responsible for calling the service modules and passing in the appropriate variables.

## Style Guidelines

Style guidelines based on:

- [Terraform Style Conventions](https://www.terraform.io/docs/language/syntax/style.html)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Google Cloud's Best Practices for Terraform](https://cloud.google.com/docs/terraform/best-practices-for-terraform)

### General Guidelines

1. All code should be formated to use the [HashiCorp Terraform style guidelines](https://developer.hashicorp.com/terraform/language/syntax/style) by utilizing the command `terraform fmt` as part of a [pre-commit](https://github.com/antonbabenko/pre-commit-terraform) hook.
2. Name all configuration objects using `underscores` to delimit words and not `dashes`.
    1. Resources, Data Sources, Variables, Outputs, etc.
    2. Does not apply to naming of cloud resources.
3. Do not repeat resource type in resource name.

<table>
<tr></tr>
<tr>
<td>  :heavy_check_mark: </td>
<td>

```hcl
resource "azurerm_resource_group" "network" {
    name     = var.network_resource_group_name
    location = var.location
}
```

</td>
<tr></tr>
<tr>
<td> :x: </td>
<td>

```hcl
resource "azurerm_resource_group" "network_resource_group" {
    name     = var.network_resource_group_name
    location = var.location
}
```

</td>
</tr>
</table>

4. Include argument count / for_each inside resource or data source block as the **first argument** at the top and separate by newline after it.
5. Tags, if supported by a resource, should be included as the **last real argument**, following by `depends_on` and `lifecycle`, if necessary.
    1. If `depends_on` and `lifecycle` are used, they should be separated by a single empty line. If `depends_on` and `lifecycle` are not used, tags should be the last argument.
6. When using conditions in an argument (`count` / `for_each`) **prefer** boolean values instead of using length or other expressions.

<table>
<tr></tr>
<tr>
<td>  Best </td>
<td>

```hcl
resource "azurerm_resource_group" "network" {
    count    = var.create_network_resource_group ? 1 : 0
    name     = var.network_resource_group_name
    location = var.location
}
```

</td>
<tr></tr>
<tr>
<td> Acceptable </td>
<td>

```hcl
resource "azurerm_resource_group" "network" {
    count    = length(var.create_network_resource_group) ? 1 : 0
    name     = var.network_resource_group_name
    location = var.location
}
```

</td>
</tr>
</table>

7. To simplify references to resources, resources should be named `this` if there is no more descriptive/general name available or if it is the only one of its type (for example, a single load balancer for an entire module).
    1. It takes extra mental work to remember `azurerm_load_balancer.my_special_resource.id` versus `azurerm_load_balancer.this.id`.
8. Always use singular nouns for names
9.

Resource name should be named this if there is no more descriptive and general name available, or if the resource module creates a single resource of this type (eg, in AWS VPC module there is a single resource of type aws_nat_gateway and multiple resources of typeaws_route_table, so aws_nat_gateway should be named this and aws_route_table should have more descriptive names - like private, public, database).