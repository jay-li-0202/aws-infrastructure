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

variable "app" {
  type = string
}

variable "admin_cidr_blocks" {
  type = list(string)
}

variable "task_execution_role_arn" {
  type = string
}

variable "task_security_group_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
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

variable "ecs_sg_id" {
  type = string
}

variable "deregistration_delay" {
  type    = string
  default = "30"
}

variable "lb_access_logs_expiration_days" {
  type    = string
  default = "3"
}

variable "public_zone_id" {
  type = string
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

variable "public_zone_name" {
  type = string
}

variable "disco_namespace_id" {
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

variable "fargate_cluster_name" {
  type = string
}

variable "fargate_cluster_id" {
  type = string
}

variable "site_version" {
  type = string
}

variable "site_image" {
  type = string
}

variable "site_port" {
  type    = string
  default = 80
}

variable "site_min_instances" {
  type    = string
  default = 1
}

variable "site_max_instances" {
  type    = string
  default = 2
}

variable "site_cpu" {
  type    = string
  default = 256
}

variable "site_memory" {
  type    = string
  default = 512
}

output "lb_arn" {
  value = aws_lb.main.arn
}

output "lb_listener_arn" {
  value = aws_lb_listener.https.arn
}

output "cert_arn" {
  value = aws_acm_certificate.main.arn
}
