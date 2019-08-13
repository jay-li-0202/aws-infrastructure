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

variable "elasticsearch_version" {
}

variable "elasticsearch_volume_size" {
}

variable "elasticsearch_master_instance_type" {
}

variable "elasticsearch_master_cluster_size" {
}

variable "elasticsearch_data_instance_type" {
}

variable "elasticsearch_data_cluster_size" {
}

provider "aws" {
  version             = "~> 2.23.0"
  region              = var.aws_region
  profile             = var.aws_profile
  allowed_account_ids = [var.aws_account_id]
}

terraform {
  backend "s3" {
    key = "elasticsearch/terraform.tfstate"
  }
}

module "elasticsearch" {
  source = "../../modules/elasticsearch"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  domain_name           = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}"
  elasticsearch_version = var.elasticsearch_version
  volume_size           = var.elasticsearch_volume_size

  master_enabled        = true
  master_instance_type  = var.elasticsearch_master_instance_type
  master_instance_count = var.elasticsearch_master_cluster_size
  data_instance_type    = var.elasticsearch_data_instance_type
  data_instance_count   = var.elasticsearch_data_cluster_size

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  subnet_ids = [
    element(data.terraform_remote_state.vpc.outputs.public_subnet_ids, 0),
    element(data.terraform_remote_state.vpc.outputs.public_subnet_ids, 1),
  ]

  private_zone_id = data.terraform_remote_state.dns.outputs.private_zone_id

  log_group_retention_in_days = 120
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

output "es_endpoint" {
  value = module.elasticsearch.endpoint
}

output "kibana_endpoint" {
  value = module.elasticsearch.kibana_endpoint
}
