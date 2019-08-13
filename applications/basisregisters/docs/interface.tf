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

variable "datadog_logging_lambda" {
  type = string
}

variable "app" {
  type = string
}

variable "vpc_id" {
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

variable "cert_public_zone_name" {
  type = string
}

variable "cert_public_zone_id" {
  type = string
}

variable "public_zone_id" {
  type = string
}

variable "deregistration_delay" {
  type    = string
  default = "30"
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

output "target_group_id" {
  value = aws_lb_target_group.docs.id
}
