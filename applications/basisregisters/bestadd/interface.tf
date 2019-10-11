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

// Predefined API keys
variable "anon_key" {
}

variable "demo_key" {
}

variable "test_key" {
}

variable "public_zone_name" {
  type = string
}

variable "alias_zone_name" {
  type = string
}

variable "api_url" {
  type    = string
  default = "bosa"
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

variable "base_host" {
  type = string
}

variable "api_stage_name" {
  type    = string
  default = "bestadd"
}

variable "api_name" {
  type    = string
  default = "bestadd"
}

variable "api_anonymous_rate_limit_per_5min" {
  type = string
}

variable "api_anonymous_waf_acl_id" {
  type = string
}

variable "vpc_link_id" {
  type = string
}
