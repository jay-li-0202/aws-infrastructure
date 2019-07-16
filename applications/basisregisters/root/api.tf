module "api" {
  source = "../api"

  region            = "${var.aws_region}"
  environment_label = "${var.environment_label}"
  environment_name  = "${var.environment_name}"

  tag_environment = "${var.tag_environment}"
  tag_product     = "${var.tag_product}"
  tag_program     = "${var.tag_program}"
  tag_contact     = "${var.tag_contact}"

  anon_key = "${var.anon_key}"
  demo_key = "${var.demo_key}"
  ui_key   = "${var.ui_key}"
  test_key = "${var.test_key}"

  api_name       = "basisregisters"
  api_stage_name = "basisregisters"

  api_url               = "api"
  public_zone_name      = "${data.terraform_remote_state.dns.outputs.public_zone_name}"
  cert_public_zone_name = "${data.terraform_remote_state.dns.outputs.public_zone_name}"
  cert_public_zone_id   = "${data.terraform_remote_state.dns.outputs.public_zone_id}"

  base_host = "public-api.${data.terraform_remote_state.dns.outputs.public_zone_name}"

  providers = {
    "aws"      = "aws"
    "aws.cert" = "aws.cert"
  }
}
