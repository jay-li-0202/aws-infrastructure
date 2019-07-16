variable "aws_region" {}
variable "aws_profile" {}
variable "aws_account_id" {}

variable "state_bucket" {}

variable "tag_environment" {}
variable "tag_product" {}
variable "tag_program" {}
variable "tag_contact" {}

provider "aws" {
  version             = "~> 2.19.0"
  region              = "${var.aws_region}"
  profile             = "${var.aws_profile}"
  allowed_account_ids = ["${var.aws_account_id}"]
}

resource "aws_s3_bucket" "state" {
  bucket        = "${var.state_bucket}"
  acl           = "private"
  force_destroy = true

  tags {
    Name        = "Terraform Remote State"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }

  versioning {
    enabled = true
  }
}

output "bucket_arn" {
  value = "${aws_s3_bucket.state.arn}"
}
