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

provider "aws" {
  version             = "~> 2.29.0"
  region              = var.aws_region
  profile             = var.aws_profile
  allowed_account_ids = [var.aws_account_id]
}

terraform {
  backend "s3" {
    key = "bootstrap/terraform.tfstate"
  }
}

module "bootstrap" {
  source = "../../modules/bootstrap/"

  environment_label = var.environment_label
  environment_name  = var.environment_name
  tag_environment   = var.tag_environment
  tag_product       = var.tag_product
  tag_program       = var.tag_program
  tag_contact       = var.tag_contact
}

output "backup_bucket_arn" {
  value = module.bootstrap.backup_bucket_arn
}

output "backup_bucket_name" {
  value = module.bootstrap.backup_bucket_name
}

output "log_bucket_arn" {
  value = module.bootstrap.log_bucket_arn
}

output "log_bucket_name" {
  value = module.bootstrap.log_bucket_name
}

output "tf_user_name" {
  value = module.bootstrap.tf_user_name
}

output "tf_user_key" {
  value = module.bootstrap.tf_user_key
}

output "tf_user_secret" {
  value = module.bootstrap.tf_user_secret
}

output "api_gateway_cloudwatch_role" {
  value = module.bootstrap.api_gateway_cloudwatch_role
}

output "rds_cloudwatch_role" {
  value = module.bootstrap.rds_cloudwatch_role
}

output "rds_s3backup_role" {
  value = module.bootstrap.rds_s3backup_role
}

output "rds_s3bucket" {
  value = module.bootstrap.rds_s3bucket
}

output "aws_region" {
  value = var.aws_region
}

output "aws_account_id" {
  value = var.aws_account_id
}
