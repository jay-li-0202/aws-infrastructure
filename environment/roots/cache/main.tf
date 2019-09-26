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

variable "cache_redis_version" {
}

variable "cache_instance_type" {
}

variable "cache_cluster_size" {
}

variable "cache_parameter_group" {
}

provider "aws" {
  version             = "~> 2.29.0"
  region              = var.aws_region
  profile             = var.aws_profile
  allowed_account_ids = [var.aws_account_id]
}

terraform {
  backend "s3" {
    key = "elasticache/terraform.tfstate"
  }
}

module "elasticache" {
  source = "../../modules/elasticache"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  domain_name           = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}"
  redis_cluster_id      = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}"
  redis_version         = var.cache_redis_version
  redis_parameter_group = var.cache_parameter_group

  node_instance_count = var.cache_cluster_size
  node_instance_type  = var.cache_instance_type

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  private_zone_id = data.terraform_remote_state.dns.outputs.private_zone_id

  bastion_sg_id = data.terraform_remote_state.bastions.outputs.bastion_security_group_id
  ecs_sg_id     = data.terraform_remote_state.fargate.outputs.fargate_security_group_id

  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
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

output "cache_endpoint" {
  value = module.elasticache.endpoint
}
