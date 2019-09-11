provider "null" {
  version = "~> 2.1.2"
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

variable "db_name" {
  type    = string
  default = "address-registry"
}

variable "db_user" {
  type    = string
  default = "address"
}

variable "db_password" {
  type = string
}

variable "sa_user" {
  type = string
}

variable "sa_pass" {
  type = string
}

variable "db_edition" {
  type = string
  default = "Standard"
}

variable "db_max_size" {
  type = string
  default = "527958016000" // 250GB
}

variable "db_type" {
  type = string
  default = "S2"
}
