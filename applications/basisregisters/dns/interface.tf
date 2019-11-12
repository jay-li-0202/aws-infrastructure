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

variable "public_zone_name" {
  description = "The public zone name for Route 53"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "api_fqdn" {
  type = string
}

variable "docs_fqdn" {
  type = string
}

variable "portal_fqdn" {
  type = string
}

variable "wms_db_fqdn" {
  type = string
}

variable "dienstverlening_fqdn" {
  type = string
}

variable "dienstverlening_api_fqdn" {
  type = string
}

variable "organisatie_fqdn" {
  type = string
}

variable "organisatie_api_fqdn" {
  type = string
}

variable "root_txt_records" {
  type = list(string)
}

output "public_zone_id" {
  value = aws_route53_zone.public.zone_id
}

output "public_zone_name" {
  value = aws_route53_zone.public.name
}

output "public_zone_name_servers" {
  value = aws_route53_zone.public.name_servers
}
