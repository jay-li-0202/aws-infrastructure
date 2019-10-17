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

variable "public_zone_name" {
  description = "The domain name to configure SES."
  type        = "string"
}

variable "enable_verification" {
  description = "Control whether or not to verify SES DNS records."
  type        = "string"
  default     = true
}

variable "mail_from_domain" {
  description = " Subdomain (of the route53 zone) which is to be used as MAIL FROM address"
  type        = "string"
}

variable "public_zone_id" {
  description = "Route53 host zone ID to enable SES."
  type        = "string"
}

variable "dmarc_rua" {
  description = "Email address for capturing DMARC aggregate reports."
  type        = "string"
}

output "smtp_password" {
  value = aws_iam_access_key.smtp.ses_smtp_password
}

output "smtp_user" {
  value = aws_iam_access_key.smtp.user
}
