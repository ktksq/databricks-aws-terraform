variable "databricks_account_username" {}
variable "databricks_account_password" {}
variable "databricks_account_id" {}

variable "access_key" {}
variable "secret_key" {}

variable "tags" {
  default = {}
}

variable "owner" {}

variable "cidr_block" {
  default = "10.4.0.0/16"
}

variable "region" {}

// See https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

// locals {
//   prefix = "e2-demo-ktksk"
// }

locals {
  prefix = "e2-demo-ktksk-${random_string.naming.result}"
}