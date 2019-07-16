provider "template" {
  version = "~> 2.1.2"
}

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

variable "app" {
  type = "string"
}

variable "admin_cidr_blocks" {
  type = "list"
}

variable "cpu" {
  type    = "string"
  default = 256
}

variable "memory" {
  type    = "string"
  default = 512
}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "container_ports" {
  type = "list"
}

variable "vpc_id" {
  type = "string"
}

variable "lb_port" {
  type    = "string"
  default = "80"
}

variable "lb_https_port" {
  type    = "string"
  default = "443"
}

variable "lb_protocol" {
  type    = "string"
  default = "HTTP"
}

variable "ecs_sg_id" {
  type = "string"
}

variable "deregistration_delay" {
  type    = "string"
  default = "30"
}

variable "lb_access_logs_expiration_days" {
  type    = "string"
  default = "3"
}

variable "public_zone_id" {
  type = "string"
}

variable "cert_public_zone_name" {
  type = "string"
}

variable "cert_public_zone_id" {
  type = "string"
}

variable "public_zone_name" {
  type = "string"
}

variable "private_zone_name" {
  type = "string"
}

variable "disco_zone_name" {
  type = "string"
}

variable "disco_namespace_id" {
  type = "string"
}

output "lb_arn" {
  value = "${aws_lb.main.arn}"
}

output "lb_listener_arn" {
  value = "${aws_lb_listener.https.arn}"
}

output "cert_arn" {
  value = "${aws_acm_certificate.main.arn}"
}
