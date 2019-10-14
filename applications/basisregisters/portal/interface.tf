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

variable "cert_public_zone_name" {
  type = string
}

variable "cert_alias_zone_name" {
  type = string
}

variable "cert_alias_zone_id" {
  type = string
}

variable "cert_public_zone_id" {
  type = string
}

output "cert_arn" {
  value = aws_acm_certificate.portal.arn
}
