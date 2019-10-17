module "ses" {
  source = "../ses"

  region            = var.aws_region
  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  app = "basisregisters"

  public_zone_name      = data.terraform_remote_state.dns.outputs.public_zone_name
  public_zone_id     = data.terraform_remote_state.dns.outputs.public_zone_id
  mail_from_domain   = "email.${data.terraform_remote_state.dns.outputs.public_zone_name}"
  dmarc_rua = var.tag_contact
}

output "main_smtp_password" {
  value = module.ses.smtp_password
}

output "main_smtp_user" {
  value = module.ses.smtp_user
}

module "ses_alias" {
  source = "../ses"

  region            = var.aws_region
  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  app = "basisregisters"

  public_zone_name       = module.dns.public_zone_name
  public_zone_id     = module.dns.public_zone_id
  mail_from_domain   = "email.${module.dns.public_zone_name}"
  dmarc_rua = var.tag_contact
}

output "alias_smtp_password" {
  value = module.ses_alias.smtp_password
}

output "alias_smtp_user" {
  value = module.ses_alias.smtp_user
}
