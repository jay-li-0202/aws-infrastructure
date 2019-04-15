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

variable "bastion_cluster" {
  type = "string"
}

variable "bastion_subnets" {
  type = "list"
}

variable "bastion_vpc" {
  type = "string"
}

variable "cleanup_schedule" {
  type = "string"
}

provider "archive" {
  version = "~> 1.2.1"
}

output "bastion_api_key" {
  value = "${aws_api_gateway_api_key.bastions.value}"
}
