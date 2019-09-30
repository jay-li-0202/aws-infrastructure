provider "template" {
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

variable "vpc_cidr_block" {
  type = string
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

variable "lb_protocol" {
  type    = string
  default = "HTTP"
}

variable "api_lb_arn" {
  type = string
}

variable "api_lb_dns_name" {
  type = string
}

variable "api_lb_zone_id" {
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

# If the average CPU utilization over a minute drops to this threshold,
# the number of containers will be reduced (but not below min_instances).
variable "ecs_as_cpu_low_threshold_per" {
  default = "30"
}

# If the average CPU utilization over a minute rises to this threshold,
# the number of containers will be increased (but not above max_instances).
variable "ecs_as_cpu_high_threshold_per" {
  default = "80"
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

variable "image" {
  type = string
}

variable "cpu" {
  type    = string
  default = 256
}

variable "memory" {
  type    = string
  default = 512
}

variable "min_instances" {
  type    = string
  default = 1
}

variable "max_instances" {
  type    = string
  default = 2
}

variable "container_port" {
  type = string
}

variable "ecs_sg_id" {
  type = string
}

variable "ecs_sg_ports" {
  type = list(string)
}

variable "docs_target_group_arn" {
  type = string
}

variable "extracts_expiration_days" {
  type = string
}

variable "extract_bundler_image" {
  type = string
}

variable "extract_bundler_enabled" {
  type    = string
  default = true
}

variable "extract_bundler_cpu" {
  type    = string
  default = 256
}

variable "extract_bundler_memory" {
  type    = string
  default = 512
}

variable "extract_bundler_schedule" {
  type    = string
  default = "cron(0 22 * * ? *)"
}

output "task_security_group_id" {
  value = var.ecs_sg_id
}

output "target_group_id" {
  value = aws_lb_target_group.api.id
}
