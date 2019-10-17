provider "aws" {
  version = "~> 2.32.0"
}

provider "aws" {
  version = "~> 2.32.0"
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

variable "public_zone_id" {
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

variable "portal_fqdn" {
  type = string
}

variable "auth_fqdn" {
  type = string
}

output "cert_arn" {
  value = aws_acm_certificate.portal.arn
}

output "portal_fqdn" {
  value = aws_route53_record.portal.fqdn
}

output "auth_fqdn" {
  value = aws_route53_record.auth.fqdn
}
