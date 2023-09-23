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
