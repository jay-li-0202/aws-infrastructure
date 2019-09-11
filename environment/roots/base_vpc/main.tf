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

variable "vpc_cidr_block" {
}

provider "aws" {
  version             = "~> 2.23.0"
  region              = var.aws_region
  profile             = var.aws_profile
  allowed_account_ids = [var.aws_account_id]
}

terraform {
  backend "s3" {
    key = "vpc/terraform.tfstate"
  }
}

data "aws_availability_zones" "zones" {
}

module "vpc" {
  source = "../../modules/vpc"

  environment_label = var.environment_label
  environment_name  = var.environment_name
  tag_environment   = var.tag_environment
  tag_product       = var.tag_product
  tag_program       = var.tag_program
  tag_contact       = var.tag_contact

  region = var.aws_region

  cidr_block = var.vpc_cidr_block

  private_subnets = [
    cidrsubnet(var.vpc_cidr_block, 3, 5),
    cidrsubnet(var.vpc_cidr_block, 3, 6),
    cidrsubnet(var.vpc_cidr_block, 3, 7),
  ]

  public_subnets = [
    cidrsubnet(var.vpc_cidr_block, 5, 0),
    cidrsubnet(var.vpc_cidr_block, 5, 1),
    cidrsubnet(var.vpc_cidr_block, 5, 2),
  ]

  availability_zones = data.aws_availability_zones.zones.names

  log_group_retention_in_days = 120
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "private_availability_zones" {
  value = module.vpc.private_availability_zones
}

output "public_availability_zones" {
  value = module.vpc.public_availability_zones
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "s3_vpce_id" {
  value = module.vpc.s3_vpce_id
}

output "cidr_block" {
  value = module.vpc.cidr_block
}

output "nat_ips" {
  value = module.vpc.nat_ips
}
