variable "aws_region" {
}

variable "aws_profile" {
}

variable "aws_account_id" {
}

variable "azure_subscription_id" {
}

variable "azure_tenant_id" {
}

variable "environment_label" {
}

variable "environment_name" {
}

variable "tag_environment" {
}

variable "tag_product" {
}

variable "tag_program" {
}

variable "tag_contact" {
}

variable "state_bucket" {
}

variable "disco_zone_name" {
  type    = string
  default = "basisregisters.disco"
}

variable "sql_username" {
}

variable "sql_password" {
}

variable "azure_sql_password" {
}

// Predefined API keys
variable "anon_key" {
}

variable "demo_key" {
}

variable "ui_key" {
}

variable "test_key" {
}

variable "bosa_anon_key" {
}

variable "bosa_demo_key" {
}

variable "bosa_test_key" {
}

variable "admin_cidr_blocks" {
  type = list(string)
}

provider "aws" {
  version             = "~> 2.29.0"
  region              = var.aws_region
  profile             = var.aws_profile
  allowed_account_ids = [var.aws_account_id]
}

provider "aws" {
  alias               = "cert"
  version             = "~> 2.29.0"
  region              = "us-east-1"
  profile             = var.aws_profile
  allowed_account_ids = [var.aws_account_id]
}

provider "azurerm" {
  version         = "~> 1.33.1"
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
}

terraform {
  backend "s3" {
    key = "app-basisregisters/terraform.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket  = var.state_bucket
    region  = var.aws_region
    key     = "vpc/terraform.tfstate"
    profile = var.aws_profile
  }
}

data "terraform_remote_state" "dns" {
  backend = "s3"

  config = {
    bucket  = var.state_bucket
    region  = var.aws_region
    key     = "dns/terraform.tfstate"
    profile = var.aws_profile
  }
}

data "terraform_remote_state" "fargate" {
  backend = "s3"

  config = {
    bucket  = var.state_bucket
    region  = var.aws_region
    key     = "fargate/terraform.tfstate"
    profile = var.aws_profile
  }
}

data "terraform_remote_state" "sqlserver" {
  backend = "s3"

  config = {
    bucket  = var.state_bucket
    region  = var.aws_region
    key     = "sqlserver/terraform.tfstate"
    profile = var.aws_profile
  }
}

data "terraform_remote_state" "cache" {
  backend = "s3"

  config = {
    bucket  = var.state_bucket
    region  = var.aws_region
    key     = "elasticache/terraform.tfstate"
    profile = var.aws_profile
  }
}

data "terraform_remote_state" "datadog" {
  backend = "s3"

  config = {
    bucket  = var.state_bucket
    region  = var.aws_region
    key     = "datadog_aws/terraform.tfstate"
    profile = var.aws_profile
  }
}

// module "building-registry" {
//   source = "../grar/building2"
// }
