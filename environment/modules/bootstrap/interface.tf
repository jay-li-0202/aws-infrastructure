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

output "backup_bucket_arn" {
  value = "${aws_s3_bucket.backup.arn}"
}

output "backup_bucket_name" {
  value = "${aws_s3_bucket.backup.bucket}"
}

output "log_bucket_arn" {
  value = "${aws_s3_bucket.log.arn}"
}

output "log_bucket_name" {
  value = "${aws_s3_bucket.log.bucket}"
}

output "tf_user_name" {
  value = "${aws_iam_user.tf.name}"
}

output "tf_user_key" {
  value = "${aws_iam_access_key.tf.id}"
}

output "tf_user_secret" {
  value = "${aws_iam_access_key.tf.secret}"
}

output "api_gateway_cloudwatch_role" {
  value = "${aws_iam_role.api_gateway.arn}"
}

output "rds_cloudwatch_role" {
  value = "${aws_iam_role.rds.arn}"
}

output "rds_s3backup_role" {
  value = "${aws_iam_role.rds-backup.arn}"
}

output "rds_s3bucket" {
  value = "${aws_s3_bucket.rds-backup.arn}"
}
