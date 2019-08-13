variable "aws_region" {
}

variable "aws_profile" {
}

variable "aws_account_id" {
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

variable "sql_version" {
}

variable "sql_major_version" {
}

variable "sql_family" {
}

variable "sql_instance_type" {
}

variable "sql_username" {
}

variable "sql_password" {
}

variable "sql_storage" {
}

variable "sql_backup_retention_period" {
}

variable "sql_multi_az" {
}

variable "sql_performance_insights_retention_period" {
}

provider "aws" {
  version             = "~> 2.23.0"
  region              = var.aws_region
  profile             = var.aws_profile
  allowed_account_ids = [var.aws_account_id]
}

terraform {
  backend "s3" {
    key = "sqlserver/terraform.tfstate"
  }
}

module "sqlserver" {
  source = "../../modules/sqlserver"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  sql_version                               = var.sql_version
  sql_major_version                         = var.sql_major_version
  sql_family                                = var.sql_family
  sql_instance_type                         = var.sql_instance_type
  sql_username                              = var.sql_username
  sql_password                              = var.sql_password
  sql_storage                               = var.sql_storage
  sql_backup_retention_period               = var.sql_backup_retention_period
  sql_multi_az                              = var.sql_multi_az
  sql_performance_insights_retention_period = var.sql_performance_insights_retention_period

  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  monitoring_role   = data.terraform_remote_state.bootstrap.outputs.rds_cloudwatch_role
  rds_s3backup_role = data.terraform_remote_state.bootstrap.outputs.rds_s3backup_role

  bastion_sg_id = data.terraform_remote_state.bastions.outputs.bastion_security_group_id
  ecs_sg_id     = data.terraform_remote_state.fargate.outputs.fargate_security_group_id

  private_zone_id = data.terraform_remote_state.dns.outputs.private_zone_id
  subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}

data "terraform_remote_state" "bootstrap" {
  backend = "s3"

  config = {
    bucket  = var.state_bucket
    region  = var.aws_region
    key     = "bootstrap/terraform.tfstate"
    profile = var.aws_profile
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

data "terraform_remote_state" "bastions" {
  backend = "s3"

  config = {
    bucket  = var.state_bucket
    region  = var.aws_region
    key     = "bastions/terraform.tfstate"
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

output "address" {
  value = module.sqlserver.address
}

output "endpoint" {
  value = module.sqlserver.endpoint
}

