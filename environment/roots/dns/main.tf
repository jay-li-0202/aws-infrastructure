variable "aws_region" {
}

variable "aws_profile" {
}

variable "aws_account_id" {
}

variable "state_bucket" {
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

variable "public_zone_name" {
}

variable "private_zone_name" {
}

provider "aws" {
  version             = "~> 2.23.0"
  region              = var.aws_region
  profile             = var.aws_profile
  allowed_account_ids = [var.aws_account_id]
}

terraform {
  backend "s3" {
    key = "dns/terraform.tfstate"
  }
}

module "dns" {
  source = "../../modules/dns/"

  environment_label = var.environment_label
  environment_name  = var.environment_name
  tag_environment   = var.tag_environment
  tag_product       = var.tag_product
  tag_program       = var.tag_program
  tag_contact       = var.tag_contact

  public_zone_name  = var.public_zone_name
  private_zone_name = var.private_zone_name
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
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

output "public_zone_id" {
  value = module.dns.public_zone_id
}

output "public_zone_name" {
  value = module.dns.public_zone_name
}

output "public_zone_name_servers" {
  value = module.dns.public_zone_name_servers
}

output "private_zone_id" {
  value = module.dns.private_zone_id
}

output "private_zone_name" {
  value = module.dns.private_zone_name
}

output "private_zone_name_servers" {
  value = module.dns.private_zone_name_servers
}

