variable "aws_region" {}
variable "aws_profile" {}
variable "aws_account_id" {}

variable "environment_label" {}
variable "environment_name" {}

variable "tag_environment" {}
variable "tag_product" {}
variable "tag_program" {}
variable "tag_contact" {}

variable "datadog_external_id" {}
variable "datadog_api_key" {}

provider "aws" {
  version             = "~> 2.4.0"
  region              = "${var.aws_region}"
  profile             = "${var.aws_profile}"
  allowed_account_ids = ["${var.aws_account_id}"]
}

terraform {
  backend "s3" {
    key = "datadog_aws/terraform.tfstate"
  }
}

module "datadog" {
  source = "../../modules/datadog/"

  environment_label = "${var.environment_label}"
  environment_name  = "${var.environment_name}"

  tag_environment = "${var.tag_environment}"
  tag_product     = "${var.tag_product}"
  tag_program     = "${var.tag_program}"
  tag_contact     = "${var.tag_contact}"

  datadog_external_id = "${var.datadog_external_id}"
  datadog_api_key     = "${var.datadog_api_key}"
}

output "datadog_user_name" {
  value = "${module.datadog.datadog_user_name}"
}

output "datadog_user_key" {
  value = "${module.datadog.datadog_user_key}"
}

output "datadog_user_secret" {
  value = "${module.datadog.datadog_user_secret}"
}

output "datadog_role" {
  value = "${module.datadog.datadog_role}"
}

output "datadog_api_key" {
  value = "${var.datadog_api_key}"
}

output "datadog_lambda_arn" {
  value = "${module.datadog.datadog_lambda_arn}"
}
