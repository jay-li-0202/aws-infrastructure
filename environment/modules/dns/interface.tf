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

variable "private_zone_name" {
  description = "The private name for Route 53"
  type        = string
}

variable "vpc_id" {
  type = string
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

output "private_zone_id" {
  value = aws_route53_zone.private.zone_id
}

output "private_zone_name" {
  value = aws_route53_zone.private.name
}

output "private_zone_name_servers" {
  value = aws_route53_zone.private.name_servers
}
