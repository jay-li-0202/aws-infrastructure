provider "aws" {
  version = "~> 2.23.0"
}

provider "aws" {
  version = "~> 2.23.0"
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

