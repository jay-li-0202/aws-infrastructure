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

variable "api_anonymous_rate_limit_per_5min" {
  type    = string
  default = "300"
}

output "acl_id" {
  value = aws_wafregional_web_acl.api_key.id
}

output "api_anonymous_rate_limit_per_5min" {
  value = var.api_anonymous_rate_limit_per_5min
}
