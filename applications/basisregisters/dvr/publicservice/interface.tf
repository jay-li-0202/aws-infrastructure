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

variable "app" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ecs_sg_id" {
  type = string
}

variable "ecs_sg_ports" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "lb_port" {
  type    = string
  default = "80"
}

variable "lb_https_port" {
  type    = string
  default = "443"
}

variable "lb_protocol" {
  type    = string
  default = "HTTP"
}

variable "lb_access_logs_expiration_days" {
  type    = string
  default = "3"
}

variable "cert_alias_zone_name" {
  type = string
}

variable "cert_alias_zone_id" {
  type = string
}

variable "cert_public_zone_name" {
  type = string
}

variable "cert_public_zone_id" {
  type = string
}

variable "public_zone_id" {
  type = string
}

variable "public_zone_name" {
  type = string
}

variable "private_zone_name" {
  type = string
}

variable "disco_zone_name" {
  type = string
}

variable "disco_namespace_id" {
  type = string
}

variable "deregistration_delay" {
  type    = string
  default = "30"
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

variable "api_version" {
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

variable "api_image" {
  type = string
}

variable "api_cpu" {
  type    = string
  default = 256
}

variable "api_memory" {
  type    = string
  default = 512
}

variable "orafin_enabled" {
  type    = string
  default = true
}

variable "orafin_image" {
  type = string
}

variable "orafin_cpu" {
  type    = string
  default = 256
}

variable "orafin_memory" {
  type    = string
  default = 512
}

variable "orafin_schedule" {
  type    = string
  default = "cron(0/5 * * * ? *)"
}

variable "orafin_ftp_host" {
  type = string
}

variable "orafin_ftp_user" {
  type = string
}

variable "orafin_ftp_password" {
  type = string
}

variable "orafin_ftp_path" {
  type = string
}

variable "projections_image" {
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

variable "ui_image" {
  type = string
}

variable "ui_min_instances" {
  type    = string
  default = 1
}

variable "ui_cpu" {
  type    = string
  default = 256
}

variable "ui_memory" {
  type    = string
  default = 512
}

variable "sa_user" {
  type = string
}

variable "sa_pass" {
  type = string
}

variable "db_server" {
  type = string
}

variable "db_name" {
  type    = string
  default = "publicservice-registry"
}

variable "db_user" {
  type    = string
  default = "publicservice"
}

variable "db_password" {
  type = string
}

variable "acm_host" {
  type = string
}

variable "acm_shared_signing_key" {
  type = string
}

variable "acm_cookie_name" {
  type = string
}

variable "acm_client_id" {
  type = string
}

variable "acm_client_secret" {
  type = string
}

variable "task_security_group_id" {
  type = string
}

variable "port_range" {
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

output "lb_arn" {
  value = aws_lb.api.arn
}

output "lb_listener_arn" {
  value = aws_lb_listener.https.arn
}
