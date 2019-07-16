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

variable "cpu" {
  type    = string
  default = 256
}

variable "memory" {
  type    = string
  default = 512
}

variable "image" {
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

variable "cert_public_zone_name" {
  type = string
}

variable "cert_public_zone_id" {
  type = string
}

variable "fargate_cluster_id" {
  type = string
}

variable "replicas" {
  type    = string
  default = 1
}

variable "container_port" {
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

variable "ecs_sg_id" {
  type = string
}

variable "disco_namespace_id" {
  type = string
}

output "task_security_group_id" {
  value = var.ecs_sg_id
}

