provider "null" {
  version = "~> 2.1.2"
}

variable "region" {
  type = string
}

variable "environment_label" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "tag_environment" {
  type = string
}

variable "tag_product" {
  type = string
}

variable "tag_program" {
  type = string
}

variable "tag_contact" {
  type = string
}

variable "ops_lb_arn" {
  type = string
}

variable "ops_lb_listener_arn" {
  type = string
}

variable "ops_cert_arn" {
  type = string
}

variable "datadog_api_key" {
  type = string
}

variable "datadog_logging_lambda" {
  type = string
}

variable "datadog_env" {
  type = string
}

variable "task_execution_role_arn" {
  type = string
}

variable "task_security_group_id" {
  type = string
}

variable "app" {
  type = string
}

variable "port_range" {
}

variable "private_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "public_zone_name" {
  type = string
}

variable "alias_zone_name" {
  type = string
}

variable "public_zone_id" {
  type = string
}

variable "disco_namespace_id" {
  type = string
}

variable "deregistration_delay" {
  type    = string
  default = "30"
}

variable "disco_zone_name" {
  type = string
}

# If the average CPU utilization over a minute drops to this threshold,
# the number of containers will be reduced (but not below api_min_instances).
variable "ecs_as_cpu_low_threshold_per" {
  default = "30"
}

# If the average CPU utilization over a minute rises to this threshold,
# the number of containers will be increased (but not above api_max_instances).
variable "ecs_as_cpu_high_threshold_per" {
  default = "80"
}

variable "db_server" {
  type = string
}

variable "db_name" {
  type    = string
  default = "building-registry"
}

variable "db_user" {
  type    = string
  default = "building"
}

variable "db_password" {
  type = string
}

variable "sa_user" {
  type = string
}

variable "sa_pass" {
  type = string
}

variable "wms_db_server" {
  type = string
}

variable "wms_db_name" {
  type = string
}

variable "wms_db_user" {
  type = string
}

variable "wms_db_password" {
  type = string
}

variable "fargate_cluster_name" {
  type = string
}

variable "fargate_cluster_id" {
  type = string
}

variable "fargate_cluster_arn" {
  type = string
}

variable "legacy_api_image" {
  type = string
}

variable "import_api_image" {
  type = string
}

variable "extract_api_image" {
  type = string
}

variable "api_min_instances" {
  type    = string
  default = 1
}

variable "api_max_instances" {
  type    = string
  default = 2
}

variable "api_cpu" {
  type    = string
  default = 256
}

variable "api_memory" {
  type    = string
  default = 512
}

variable "projections_image" {
  type = string
}

variable "syndication_image" {
  type = string
}

variable "projections_min_instances" {
  type    = string
  default = 1
}

variable "projections_cpu" {
  type    = string
  default = 256
}

variable "projections_memory" {
  type    = string
  default = 512
}

variable "cache_server" {
  type = string
}

variable "cache_image" {
  type = string
}

variable "cache_enabled" {
  type    = string
  default = true
}

variable "cache_cpu" {
  type    = string
  default = 256
}

variable "cache_memory" {
  type    = string
  default = 512
}

variable "cache_schedule" {
  type    = string
  default = "cron(0/5 * * * ? *)"
}
