# Databricks Terraform provider for AWS
## Overview
- aws-e2workspace
    - Create E2 Workspace
- aws-unitycatalog
    - Enable Unity Catalog on your workspace
    - Add External location 

## Inputs
- aws-e2workspace/variables.tf
- aws-unitycatalog/variables.tf


## Usage Example
- init terraform state
```
terraform init
```
- apply settings
```
terraform apply -var-file="secret.tfvars"
```
- destroy the settings
```
terraform destroy -var-file="secret.tfvars"
```