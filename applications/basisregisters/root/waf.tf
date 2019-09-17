module "waf" {
  source = "../waf"

  region            = var.aws_region
  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  app = "basisregisters"

  // https://github.com/terraform-providers/terraform-provider-aws/pull/9946
  api_anonymous_rate_limit_per_5min = "2000"
}
