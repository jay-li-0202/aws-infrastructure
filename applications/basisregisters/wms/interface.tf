provider "null" {
  version = "~> 2.1.2"
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

variable "rg_name" {
  type = string
}

variable "db_server" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type    = string
  default = "wms"
}

variable "db_password" {
  type = string
}

variable "db_reader_password" {
  type = string
}

variable "sa_user" {
  type = string
}

variable "sa_pass" {
  type = string
}

variable "sql_port" {
  type = string
}

variable "db_edition" {
  type    = string
  default = "Standard"
}

variable "db_max_size" {
  type    = string
  default = "268435456000" // 250GB
}

variable "db_type" {
  type    = string
  default = "S2"
}

variable "allowed_ips" {
  type = list(string)
}

output "wms_fqdn" {
  value = aws_route53_record.wms.fqdn
}

output "azure_db_fqdn" {
  value = azurerm_sql_server.wms.fully_qualified_domain_name
}
