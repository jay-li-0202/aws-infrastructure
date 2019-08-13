provider "archive" {
  version = "~> 1.2.1"
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

variable "bastion_cluster" {
  type = string
}

variable "bastion_subnets" {
  type = list(string)
}

variable "bastion_vpc" {
  type = string
}

variable "cleanup_schedule" {
  type = string
}

variable "datadog_logging_lambda" {
  type = string
}

output "bastion_api_endpoint" {
  value = aws_api_gateway_deployment.bastions.invoke_url
}

output "bastion_api_key" {
  value = aws_api_gateway_api_key.bastions.value
}

output "bastion_security_group" {
  value = aws_security_group.bastion.arn
}

output "bastion_security_group_id" {
  value = aws_security_group.bastion.id
}
