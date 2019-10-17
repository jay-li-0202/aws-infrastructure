#
# SES Receipt Rule
#

//  * * Ensure an s3 bucket exists and SES has write permissions to it

// variable "from_addresses" {
//   description = "List of email addresses to catch bounces and rejections"
//   type        = "list"
// }

// variable "receive_s3_bucket" {
//   description = "Name of the S3 bucket to store received emails."
//   type        = "string"
// }

// variable "receive_s3_prefix" {
//   description = "The key prefix of the S3 bucket to store received emails."
//   type        = "string"
// }

// variable "ses_rule_set" {
//   description = "Name of the SES rule set to associate rules with."
//   type        = "string"
// }

// resource "aws_ses_receipt_rule" "main" {
//   name          = "${format("%s-s3-rule", local.dash_domain)}"
//   rule_set_name = "${var.ses_rule_set}"
//   recipients    = "${var.from_addresses}"
//   enabled       = true
//   scan_enabled  = true

//   s3_action {
//     position = 1

//     bucket_name       = "${var.receive_s3_bucket}"
//     object_key_prefix = "${var.receive_s3_prefix}"
//   }
// }
