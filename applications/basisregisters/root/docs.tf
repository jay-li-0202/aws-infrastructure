module "docs" {
  source = "../docs"

  region            = var.aws_region
  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  app            = "basisregisters"
  container_port = 2080

  ecs_sg_id = data.terraform_remote_state.fargate.outputs.fargate_security_group_id
  ecs_sg_ports = [
    "2080-2080",
  ]

  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnets  = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  public_zone_id        = data.terraform_remote_state.dns.outputs.public_zone_id
  cert_public_zone_name = data.terraform_remote_state.dns.outputs.public_zone_name
  cert_public_zone_id   = data.terraform_remote_state.dns.outputs.public_zone_id
  cert_alias_zone_name  = module.dns.public_zone_name
  cert_alias_zone_id    = module.dns.public_zone_id

  datadog_logging_lambda = data.terraform_remote_state.datadog.outputs.datadog_lambda_arn
}
