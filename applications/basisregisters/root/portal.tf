variable "portal_fqdn" {
}

module "portal" {
  source = "../portal"

  region            = var.aws_region
  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  portal_fqdn = var.portal_fqdn

  public_zone_id        = data.terraform_remote_state.dns.outputs.public_zone_id
  cert_public_zone_name = data.terraform_remote_state.dns.outputs.public_zone_name
  cert_public_zone_id   = data.terraform_remote_state.dns.outputs.public_zone_id
  cert_alias_zone_name  = module.dns.public_zone_name
  cert_alias_zone_id    = module.dns.public_zone_id

  providers = {
    aws      = aws
    aws.cert = aws.cert
  }
}
