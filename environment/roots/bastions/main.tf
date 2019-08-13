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

provider "aws" {
  version             = "~> 2.23.0"
  region              = var.aws_region
  profile             = var.aws_profile
  allowed_account_ids = [var.aws_account_id]
}

terraform {
  backend "s3" {
    key = "bastions/terraform.tfstate"
  }
}

module "bastions" {
  source = "../../modules/bastions"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  bastion_cluster  = data.terraform_remote_state.fargate.outputs.fargate_cluster_arn
  bastion_subnets  = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  bastion_vpc      = data.terraform_remote_state.vpc.outputs.vpc_id
  cleanup_schedule = ""

  datadog_logging_lambda = data.terraform_remote_state.datadog.outputs.datadog_lambda_arn
}

module "bastion-cumpsd" {
  source = "../../modules/bastion_user"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  task_execution_role_arn = data.terraform_remote_state.fargate.outputs.fargate_execution_role_arn
  region                  = var.aws_region

  bastion_user = "cumpsd"
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

data "terraform_remote_state" "fargate" {
  backend = "s3"

  config = {
    bucket  = var.state_bucket
    region  = var.aws_region
    key     = "fargate/terraform.tfstate"
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

output "bastion_api_endpoint" {
  value = module.bastions.bastion_api_endpoint
}

output "bastion_api_key" {
  value = module.bastions.bastion_api_key
}

output "bastion_security_group" {
  value = module.bastions.bastion_security_group
}

output "bastion_security_group_id" {
  value = module.bastions.bastion_security_group_id
}
