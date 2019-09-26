provider "aws" {
  version = "~> 2.29.0"
}

provider "aws" {
  version = "~> 2.29.0"
  alias   = "cert"
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

variable "app" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

// Predefined API keys
variable "anon_key" {
}

variable "demo_key" {
}

variable "ui_key" {
}

variable "test_key" {
}

variable "public_zone_name" {
  type = string
}

variable "api_url" {
  type    = string
  default = "api"
}

variable "cert_public_zone_name" {
  type = string
}

variable "cert_public_zone_id" {
  type = string
}

variable "base_host" {
  type = string
}

variable "api_stage_name" {
  type    = string
  default = "api"
}

variable "api_name" {
  type    = string
  default = "api"
}

variable "api_anonymous_rate_limit_per_5min" {
  type    = string
}

variable "api_anonymous_waf_acl_id" {
  type    = string
}

output "lb_arn" {
  value = aws_lb.api.arn
}

output "lb_dns_name" {
  value = aws_lb.api.dns_name
}

output "lb_zone_id" {
  value = aws_lb.api.zone_id
}

output "vpc_link_id" {
  value = aws_api_gateway_vpc_link.api.id
}
