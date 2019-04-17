variable "environment_label" {
  type = "string"
}

variable "environment_name" {
  type = "string"
}

variable "tag_environment" {
  type = "string"
}

variable "tag_product" {
  type = "string"
}

variable "tag_program" {
  type = "string"
}

variable "tag_contact" {
  type = "string"
}

variable "datadog_external_id" {}

variable "datadog_aws_account_id" {
  default = "464622532012"
}

output "datadog_user_name" {
  value = "${aws_iam_user.datadog.name}"
}

output "datadog_user_key" {
  value = "${aws_iam_access_key.datadog.id}"
}

output "datadog_user_secret" {
  value = "${aws_iam_access_key.datadog.secret}"
}

output "datadog_role" {
  value = "${aws_iam_role.datadog.name}"
}
