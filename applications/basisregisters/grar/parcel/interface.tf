variable "region" {
  type = "string"
}

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

variable "datadog_api_key" {
  type = "string"
}

variable "datadog_logging_lambda" {
  type = "string"
}

variable "datadog_env" {
  type = "string"
}

variable "task_execution_role_arn" {
  type = "string"
}

variable "app" {
  type = "string"
}

variable "private_subnets" {
  type = "list"
}

variable "vpc_id" {
  type = "string"
}

variable "fargate_cluster_id" {
  type = "string"
}

variable "api_replicas" {
  type    = "string"
  default = 1
}

variable "projections_image" {
  type = "string"
}

variable "syndication_image" {
  type = "string"
}

variable "legacy_api_image" {
  type = "string"
}

variable "import_api_image" {
  type = "string"
}

variable "extract_api_image" {
  type = "string"
}

variable "api_cpu" {
  type    = "string"
  default = 256
}

variable "api_memory" {
  type    = "string"
  default = 512
}

variable "projections_replicas" {
  type    = "string"
  default = 1
}

variable "projections_cpu" {
  type    = "string"
  default = 256
}

variable "projections_memory" {
  type    = "string"
  default = 512
}

variable "sa_user" {
  type = "string"
}

variable "sa_pass" {
  type = "string"
}

variable "db_server" {
  type = "string"
}

variable "db_name" {
  type = "string"
  default = "parcel-registry"
}

variable "db_user" {
  type = "string"
  default = "parcel"
}

variable "db_password" {
  type = "string"
}

variable "task_security_group_id" {
  type = "string"
}

variable "port_range" {}

variable "public_zone_name" {
  type = "string"
}

variable "disco_namespace_id" {
  type = "string"
}

// variable "private_zone_name" {
//   type = "string"
// }

variable "disco_zone_name" {
  type = "string"
}

