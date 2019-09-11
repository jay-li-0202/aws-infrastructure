variable "alias_zone_name" {
}

module "dns" {
  source = "../dns"

  region            = var.aws_region
  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  vpc_id           = data.terraform_remote_state.vpc.outputs.vpc_id
  public_zone_name = var.alias_zone_name
}
