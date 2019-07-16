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

variable "region" {
  type = "string"
}

variable "bastion_user" {
  type = "string"
}

variable "image" {
  type    = "string"
  default = "basisregisters/bastion:latest"
}

variable "task_execution_role_arn" {
  type = "string"
}

provider "template" {
  version = "~> 2.1.2"
}
