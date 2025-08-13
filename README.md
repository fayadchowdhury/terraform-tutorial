# Terraform

Terraform is an Infrastructure-as-Code (IAC) tool that allows the provisioning of infrastructural components in the cloud or in a virtualized setting (think VMs/LXCs on Proxmox, EC2 instances on AWS etc.) using different providers for different platforms.

It is free and open-source and developed by HashiCorp. The open source nature of it allows rapid development of providers and Terraform has an ecosystem of many providers that can interface with APIs from almost all platforms, making Terraform the IAC tool of choice for most developers.

Terraform uses HashiCorp Configuration Language (HCL) which is a declarative way to provision infrastructural components.

The HCL code defines the state that we want the infrastructure and/or its components to be in.

- In the init phase, Terraform starts the project and identifies the providers required to interact with the platforms
- In the plan phase, Terraform drafts the series of changes required to take the platform from its current state to the desired state
- In the apply phase, Terraform applies the changes

Every object that Terraform manages is called a resource. Terraform can also record the state of infrastructural components (including those created away from Terraform or with other IAC tools) as they are seen in the real world at any time and make changes accordingly to maintain a desired state.

## Installing Terraform

Instructions can be found at [this link](https://developer.hashicorp.com/terraform), but for macOS with Homebrew installed:

```
brew install terraform
```

## Basic HCL syntax

A basic HCL file consists of repetitions of the following resource:

```
<block> <parameters> {
    key1 = value1
    key2 = value2
}
```

Where:

- block - Defines the type of block - resource/variable/output
- parameters - May be one or more of resource type (usually of type providerName_resourceName), provider specific arguments etc.
- key-value pairs - Configuration details (arguments) based on provider and desired state

## Simple Terraform workflow

- Write the declarative configuration file in HCL
- Init the Terraform project with terraform init
- Plan the execution with terraform plan
- Apply the plan with terraform apply

## Key commands

- terraform init - Initializes the project and downloads and installs provider plugins (usually mentioned as hostname/organizationalNamespace/plugin as in registry.terraform.io/hashicorp/local) as required to the .terraform/providers directory
- terraform plan - Generates a plan of execution, outlining the resources to be created and/or destoryed and/or the updates to be made
- terraform apply - Applies the execution plan
- terraform destory - Destroys the resource(s) after outlining the items to be deleted

## Provider plugins

Provider plugins are used to interact with infrastructure provisioning platforms and are available on https://registry.terraform.io courtesy of HashiCorp. There are 3 tiers of providers:

- Official providers - Owned and maintained by HashiCorp officially
- Verified providers - Partners with HashiCorp but managed by 3rd party companies
- Community providers - Maintained by individual contributors within the community

## Structuring Terraform projects

It is possible to use one or more providers within the same configuration file and to have one or more configuration files overall. It is common practice to have a main.tf file combining all of the configuration info.

## Input variables

It is more sensible to use variables insteac of hardcoding arguments and parameters. Variables may be placed in tf files as well, within the project and can be referred to later as var.variableName. Variables are defined in blocks like:

```
variable varName {
    default = default value; optional; can be overridden with -var "variableName=value" in commandline, export TF_VAR_variableName=value or, if missing, will be prompted during terraform plan and apply
    type = type from string, number, boolean, list, set, map, tuple, object etc.; optional
    description = description of variable; optional
}
```

Variables are also often defined in tfvars files, in which case they are similar to .env files (but they still have to be declared in the main configuration file, otherwise they are not picked up automatically)

```
variableName = value
```

If these tfvars files are named terraform.tfvars, terraform.tfvars.json, \*.auto.tfvars or \*.auto.tfvars.json, they are automatically loaded by terraform init. Otherwise they have to be specified with -var-file in the commandline during terraform plan and terraform apply.

If variables are defined in multiple places (cmdline, environment variables, tfvars, auto.tfvars), they are applied in the following hierarchy (topmost gets applied):

1. cmdline
2. auto.tfvars
3. tfvars
4. environment variables

## Resource attribute references

It is possible to refer to attributes from one resource in another. The best thing to do here is to refer to documentation.

For example for the random_pet resource, the resource itself may be referenced by its name and the name value may be referenced by id as ${random_pet.pet-resource-name.id}

## Resource dependency

Sometimes resources depend on each other implicitly (aptly called an implicit dependency). The resources are created logically in order of the root resource to the dependent resources, and deleted in the reverse order.

It is also possible to define a dependency explicitly (aptly called an explicit dependency) using the depends_on attribute like so:

```
resource "provider_resource" "resource_name" {
    key1 = value1
    ...
    keyN = valueN
    depends_on = [
        provider_resource.resource_name
        ...
        provider_resource.resource_name
    ]
}
```

This ensures that the dependent resource is created after the root resource is created, and deleted in the reverse order. This is way to define dependencies if the dependent resource does not reference any variable from the root resource.
