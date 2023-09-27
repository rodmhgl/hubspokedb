# Style Guidelines

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

4. Include argument `count` / `for_each` inside resource or data source block as the **first argument** at the top and separate by newline after it.
5. Tags, if supported by a resource, should be included as the **last real argument**, following by `depends_on` and `lifecycle`, if necessary.
    1. If `depends_on` and `lifecycle` are used, they should be separated by a single empty line.
    2. If `depends_on` and `lifecycle` are not used, tags should be the last argument.
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

### Variables

1. For clarity, use `name`, `description`, and `default` value for variables as defined in the "Argument Reference" section for the resource you are working with.
2. Validation support for variables is still quite limited (e.g. can't access other variables or do lookups). Plan accordingly because in many cases this feature is useless.
3. Use the plural form in a variable name when type is `list(...)` or `map(...)`.
4. Order keys in a variable block like this: `description` , `type`, `default`, `validation`.
5. Always include description on all variables even if you think it is obvious (you will need it in the future).
    1. Favor using the description from the resource documentation.
6. Prefer using simple types (`number`, `string`, `list(...)`, `map(...)`, `any`) over specific type like `object()` unless you need to have strict constraints on each key.
7. Use specific types like `map(map(string))` if all elements of the map have the same type (e.g. `string`) or can be converted to it (e.g. `number` type can be converted to `string`).
10. Use `type = any` to disable type validation starting from a certain depth or when multiple types should be supported.
9. Value `{}` is sometimes a map but sometimes an object. Use` tomap(...)` to make a map because there is currently no way to make an object.
10. Variables should have relevant and descriptive names.
    1. Inputs, local variables, and outputs representing numeric values—such as disk sizes or RAM size—must be named with units (such as `ram_size_gb`). Naming variables with units makes the expected input unit clear for configuration maintainers.
    2. To simplify conditional logic, give boolean variables positive names—for example, `enable_external_access`.
11. Variables should always provide default values where appropriate.
    1. For variables that have environment-independent values (such as disk size), provide default values.
    2. For variables that have environment-specific values (such as `project_id`), don't provide default values. This forces the calling module to provide meaningful values.
    3. Use empty defaults for variables (like empty strings `""` or lists `[]`) only when leaving the variable empty is a valid preference that the underlying cloud API will not reject.
12. Be judicious in your use of variables.
    1. Only parameterize values with a concrete use-case that must vary for each instance or environment.
    2. Adding a variable with a default value is backwards-compatible.
    3. Removing a variable is backwards-incompatible.
    4. In cases where a literal is re-used in multiple places, you can use a [local value](https://developer.hashicorp.com/terraform/language/values/locals) without exposing it as a variable.

### Outputs

Make outputs consistent and understandable outside of its scope (when a user is using a module it should be obvious the type and attribute of the value it returns).

1. Organize all outputs in an outputs.tf file.
2. Provide meaningful descriptions for all outputs.
3. The name of output should describe the property it contains and be less free-form than you would normally want.
    1. Good structure for the name of output looks like `{name}_{type}_{attribute}` , where:
        1. `{name}` is a resource or data source name without a provider prefix.` {name}` for `azurerm_subnet` is `subnet`, for `azurerm_virtual_network` it is `virtual_network`.
        2. `{type}` is a type of a resource sources
        3. `{attribute}` is an attribute returned by the output
4. If the returned value is a list, it should have a plural name.
5. Document outputs  in the README.md file. Auto-generate descriptions on commit with tools like terraform-docs.
6. Output all useful values that root modules might need to refer to or share.
7. Prefer `try()` over `element(concat(...))`
8. Don't pass outputs directly through input variables, because doing so prevents them from being properly added to the dependency graph. To ensure that implicit dependencies are created, make sure that outputs reference attributes from resources.

<table>
<tr></tr>
<tr>
<td> :+1: </td>
<td>

```hcl
output "name" {
    description = "Name of Resource Group"
    value       = azurerm_resource_group.network.name
}
```

</td>
<tr></tr>
<tr>
<td> :-1: </td>
<td>

```hcl
output "name" {
    description = "Name of Resource Group"
    value       = var.name
}
```

</td>
</tr>
</table>

### Data Sources

1. Locate data sources near to the resources that reference them. For example, if you fetch an image to be used in launching an instance, place it alongside the instance instead of collecting data resources in their own file.
2. However, if the number of data sources becomes large, consider moving them to a dedicated data.tf file.
3. To fetch data relative to the current environment, use variable or resource interpolation.
