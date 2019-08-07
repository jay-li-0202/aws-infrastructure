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
  version             = "~> 2.19.0"
  region              = var.aws_region
  profile             = var.aws_profile
  allowed_account_ids = [var.aws_account_id]
}

terraform {
  backend "s3" {
    key = "fargate/terraform.tfstate"
  }
}

module "fargate" {
  source = "../../modules/ecs"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact
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

output "fargate_cluster_id" {
  value = module.fargate.cluster_id
}

output "fargate_cluster_arn" {
  value = module.fargate.cluster_arn
}

output "fargate_cluster_name" {
  value = module.fargate.cluster_name
}

output "fargate_execution_role_arn" {
  value = module.fargate.execution_role_arn
}

output "fargate_security_group" {
  value = module.fargate.ecs_security_group
}

output "fargate_security_group_id" {
  value = module.fargate.ecs_security_group_id
}

