# Terraform-folder-structure

# Description

The repository shows how Terraform project can be structured.
# Usage

Deploying temporary review environment using Terraform workspaces:

```
$ tfenv install
$ tfenv use
$ cd infrastructure/environments/stg
$ terraform init
$ terraform plan
$ terraform apply

