variable "wms_user" {
}

variable "wms_password" {
}

variable "wms_reader_password" {
}

variable "wms_db_name" {
}

variable "wms_db_edition" {
}

variable "wms_db_max_size" {
}

variable "wms_db_type" {
}

variable "wms_location" {
}

variable "wms_allowed_ips" {
}

variable "wms_rg_name" {
}

variable "wms_db_server" {
}

module "wms" {
  source = "../wms"

  region            = var.wms_location
  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  allowed_ips = concat(
    var.wms_allowed_ips,
    [
      for idx, ip in data.terraform_remote_state.vpc.outputs.nat_ips :
      format("%s|AWS NAT IP %d", ip, (idx + 1))
    ],
  ["0.0.0.0|Allow Access To Azure Services"])

  sa_user            = var.sql_username
  sa_pass            = var.azure_sql_password
  db_name            = var.wms_db_name
  db_user            = var.wms_user
  db_password        = var.wms_password
  db_reader_password = var.wms_reader_password
  db_edition         = var.wms_db_edition
  db_max_size        = var.wms_db_max_size
  db_type            = var.wms_db_type
  rg_name            = var.wms_rg_name
  db_server          = var.wms_db_server
  sql_port           = var.wms_ssh_port_forward

  public_zone_id = data.terraform_remote_state.dns.outputs.public_zone_id
}
