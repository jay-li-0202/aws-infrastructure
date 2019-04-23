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

variable "subnet_ids" {
  type = "list"
}

variable "private_zone_id" {
  type = "string"
}

variable "sql_version" {
  type = "string"
}

variable "sql_major_version" {
  type = "string"
}

variable "sql_family" {
  type = "string"
}

variable "sql_instance_type" {
  type = "string"
}

variable "sql_username" {
  type = "string"
}

variable "sql_password" {
  type = "string"
}

variable "sql_storage" {
  type = "string"
}

variable "sql_multi_az" {
  type = "string"
}

variable "sql_backup_retention_period" {
  type = "string"
}

variable "sql_backup_window" {
  type    = "string"
  default = "03:00-05:00"
}

variable "sql_maintenance_window" {
  type    = "string"
  default = "Sun:00:00-Sun:02:00"
}

variable "monitoring_role" {
  type = "string"
}

variable "rds_s3backup_role" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

output "address" {
  value = "${aws_db_instance.basisregisters.address}"
}

output "endpoint" {
  value = "${aws_db_instance.basisregisters.endpoint}"
}
