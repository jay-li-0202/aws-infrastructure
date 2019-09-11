variable "wms_password" {
}

module "wms" {
  source = "../wms"

  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  sa_user     = var.sql_username
  sa_pass     = var.sql_password
  db_password = var.wms_password

  public_zone_id = data.terraform_remote_state.dns.outputs.public_zone_id
}
