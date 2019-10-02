module "bestadd" {
  source = "../bestadd"

  region            = var.aws_region
  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  anon_key = var.bosa_anon_key
  demo_key = var.bosa_demo_key
  test_key = var.bosa_test_key

  api_name                          = "bestadd"
  api_stage_name                    = "bestadd"
  api_anonymous_waf_acl_id          = module.waf.acl_id
  api_anonymous_rate_limit_per_5min = module.waf.api_anonymous_rate_limit_per_5min

  vpc_link_id = module.api.vpc_link_id

  api_url               = "bosa"
  public_zone_name      = data.terraform_remote_state.dns.outputs.public_zone_name
  cert_public_zone_name = data.terraform_remote_state.dns.outputs.public_zone_name
  cert_public_zone_id   = data.terraform_remote_state.dns.outputs.public_zone_id

  base_host = "public-api.${data.terraform_remote_state.dns.outputs.public_zone_name}"

  providers = {
    aws      = aws
    aws.cert = aws.cert
  }
}
