variable "aws_region" {}
variable "aws_profile" {}
variable "aws_account_id" {}

variable "environment_label" {}
variable "environment_name" {}

variable "tag_environment" {}
variable "tag_product" {}
variable "tag_program" {}
variable "tag_contact" {}

variable "state_bucket" {}

variable "disco_zone_name" {
  type    = "string"
  default = "basisregisters.disco"
}

variable "sql_username" {}
variable "sql_password" {}

provider "aws" {
  version             = "~> 2.4.0"
  region              = "${var.aws_region}"
  profile             = "${var.aws_profile}"
  allowed_account_ids = ["${var.aws_account_id}"]
}

terraform {
  backend "s3" {
    key = "app-basisregisters/terraform.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket  = "${var.state_bucket}"
    region  = "${var.aws_region}"
    key     = "vpc/terraform.tfstate"
    profile = "${var.aws_profile}"
  }
}

data "terraform_remote_state" "dns" {
  backend = "s3"

  config {
    bucket  = "${var.state_bucket}"
    region  = "${var.aws_region}"
    key     = "dns/terraform.tfstate"
    profile = "${var.aws_profile}"
  }
}

data "terraform_remote_state" "fargate" {
  backend = "s3"

  config {
    bucket  = "${var.state_bucket}"
    region  = "${var.aws_region}"
    key     = "fargate/terraform.tfstate"
    profile = "${var.aws_profile}"
  }
}

data "terraform_remote_state" "sqlserver" {
  backend = "s3"

  config {
    bucket  = "${var.state_bucket}"
    region  = "${var.aws_region}"
    key     = "sqlserver/terraform.tfstate"
    profile = "${var.aws_profile}"
  }
}

data "terraform_remote_state" "datadog" {
  backend = "s3"

  config {
    bucket  = "${var.state_bucket}"
    region  = "${var.aws_region}"
    key     = "datadog_aws/terraform.tfstate"
    profile = "${var.aws_profile}"
  }
}

// output "vpc_id" {
//   value = "${module.vpc.vpc_id}"
// }

