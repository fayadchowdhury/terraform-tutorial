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
- terraform output - Shows output variables generated from terraform apply; append variable name to print value for specific variable
- terraform show - Shows the current state of the infrastructure as stored in terraform.tfstate in a human-readable format; use -json to print in JSON format
- terraform validate - Validates the configuration files and hints at how to fix errors
- terraform fmt - Scans the configuration files in the current directory and formats them intp canonical format to standardize them and make them more readable
- terraform providers - Lists all providers used in the current configuration directory
- terraform refresh - Syncs with real world infrastructure to pick up any changes that happened outside of terraform workflow; also run automatically when commands like terraform plan or terraform apply are run; can be suppressed using -refresh-false flag
- terraform graph - Generates a dependency graph in JSON or dot that can be passed to graph visualization software like graphviz to draw the graph
- terraform state list - List all resources managed by Terraform for this configuration
- terraform state show resource_type.resource_name - List the details of the resource specified by resource_type and resource_name
- terraform state mv resource_type_1.resource_name_1 resource_type_2.resource_name_2 - Move resource specified by resource_type_1 and resource_name_1 to resource_type_2 and resource_name_2
- terraform state rm resource_type.resource_name - Remove the resource specified by resource_type and resource_name from Terraform's state so that it is no longer managed by Terraform
- terraform import resource_type.resource_name id_of_resource - Adds the resource specified by resource_type and resource_name and id_of_resource to the Terraform state so that it can be managed by Terraform that point onwards

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

## Output variables

It is possible to output variables generated locally for use elsewhere. The output block is defined as below:

```
output "output_variable_name" {
    value = value
    description = description for the output variable; optional
}
```

These are commonly used to pass information to other IAC tools like Ansible or for quick inspection of information from console.

## State

Terraform uses state to apply configurations to real-world infrastructure and creates execution plans when drifts arise. It is a single source of truth, a blueprint of sorts, and is usually stored in the terraform.tfstate file in the same directory as the configuration file.

Each resource has an ID that is tracked in the .tfstate file; some metadata specific to the resources are also tracked here. This helps Terraform figure out resource dependencies even when they are removed from the configuration file.

The Terraform state also helps performance in large-scale deployments by caching attributes and referring to changes in those attributes instead of fetching details about every resource provisioned on the platform. This is done by passing the -refresh=false flag to the plan, apply and other state-dependent commands.

It also enables collaboration when people sync to the same terraform.tfstate file stored in an accessible remote store (AWS S3 for example).

The state file also contains sensitive information which should not be uploaded to Github or other VCS. Instead they should be stored on remote state backends (AWS S3, HashiCorp Terraform Cloud etc.)

## Mutable vs immutable infrastructure

Mutable infrastructure is infrastructure that can be modified or mutated in place. The problem with that approach when applying terraform configurations is partial updates - or situations where the modification did not go through fully because of abnormalities, and future updates or modifications may fail too (configuration drift may arise too). That is why Terraform takes an immutable infrastructure approach - perform modifications on a completely new provision itself (don't upgrade, create a new version and decommission old version). This is a better approach but can fail for applications that maintain state within the provisioned infra itself.

## Lifecycle rules

These are rules written in the form of resource blocks and placed inside resource blocks too that govern the lifecycle of the resource. This is done as follows:

```
resource provider_resource resource_name {
    key1 = val1
    ...
    keyN = valN
    lifecycle {
        rule = true/false
    }
}
```

Common rules include:

- create_before_destory: Create the new resource fully before destroying the existing one
- prevent_destroy: Prevent changes (other than terraform destroy) that destroy the resource
- ignore_changes: Takes a list of attributes within the resource whose changes are ignored when computing differnces and execution plan

## Data sources

Data soruces can be used to pull information or state from resources provisioned outside of Terraform (maybe manuall created or using other IAC tools). They are accessed by specifying them as a data source and mapping the type of resource to a Terraform provider resource.

For example, to access a file created outside of Terraform workflows we can use the following:

```
data "local_file" "resource_name" {
    filename = "path/to/file"
}
```

And then the contents of the file can be accessed using resource attribute references like so:

```
data.local_file.resource_name.content
```

It is best to refer to documentation to understand what attributes are exposed when reading data sources.

## Meta-arguments - for_each

depends_on and lifecycle_rules are two kinds of meta-arguments that have already been discussed. Another meta-argument is for_each which allows looping over a map or set variable. This can be particularly useful for creating multiple resources of the same type.

For example, if we want to create N files within the same resource block, we can first define a variable and set its values to a type set like so:

```
variable "filenames" {
    type = set(string)
    default = [
        "file1Name",
        ...
        "fileNName"
    ]
}
```

Next, we can define a resource block of local_file type to create the files accordingly, like so:

```
resource "local_file" "files" {
    filename = each.value
    content = "${each.value} content"
    for_each = var.filenames
}
```

## Version constraints

It is possible to specify which versions of a provider may be used in the Terraform project using a block like so:

```
terraform {
    required_providers {
        provider_name = {
            source = "source_as_specified_in_registry"
            version = "version_string"
        }
    }
}

# Rest of configuration
```

These blocks are usually placed in the main configuration file.

The version string can be:

- just version number - exact match to version number specified
- != - not equal to the version number specified (anything but that version number)
- \> or >= - greater than or greater than or equal to the version number specified
- < or <= - less than or less than or equal to the version number specified
- ~> - pessimistically greater than the version number specified (if 1.2.0 is specified it can look for provider versions from 1.2.1 to 1.2.9 but not 1.3.0 and above)
- ~< - pessimistically less than the version number specified

## Storing state in remote-state stores

The Terraform state can be stored in remote-state stores (like AWS S3 for example), which can allow better reproducibility and collaboration. This requires a terraform block definition with the backend attribute configured like so:

```
terraform {
    backend "s3" {
        bucket = bucket-name
        key = key-name
        region = region-name
    }
}
```

Once that is done, we have to run terraform init again to allow Terraform to store the state file in the specified remote-state store.

Other remote-stores may need to be configured differently.

## Import

Terraform can also be used to manage resources that have already been provisioned (different from data sources, which pulls information from the deployed resources).
