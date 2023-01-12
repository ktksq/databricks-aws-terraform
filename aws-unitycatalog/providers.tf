terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      version = "1.8.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.49.0"
    }
  }
}

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  default_tags {
   tags = {
    Project   = "Create Databricks with Terraform"
    ManagedBy = "Terraform"
    Owner     = var.owner
    }
  }
}

// initialize provider in "MWS" mode for account-level resources
provider "databricks" {
  alias      = "mws"
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id
  username   = var.databricks_account_username
  password   = var.databricks_account_password
}

// initialize provider at workspace level, to create UC resources
provider "databricks" {
  alias    = "workspace"
  host     = var.databricks_workspace_url
  username = var.databricks_account_username
  password = var.databricks_account_password
}