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
