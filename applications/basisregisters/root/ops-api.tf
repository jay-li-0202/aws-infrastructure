module "ops-api" {
  source = "../ops-api"

  region            = var.aws_region
  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  app = "basisregisters"

  container_ports = [
    "2000-2006",
    "3000-3006",
    "4000-4006",
    "5000-5006",
    "6000-6006",
    "7000-7006",
  ]

  ecs_sg_id = data.terraform_remote_state.fargate.outputs.fargate_security_group_id

  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnets    = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  private_subnets   = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  admin_cidr_blocks = var.admin_cidr_blocks

  disco_namespace_id    = aws_service_discovery_private_dns_namespace.basisregisters.id
  public_zone_id        = data.terraform_remote_state.dns.outputs.public_zone_id
  public_zone_name      = data.terraform_remote_state.dns.outputs.public_zone_name
  private_zone_name     = data.terraform_remote_state.dns.outputs.private_zone_name
  disco_zone_name       = var.disco_zone_name
  cert_public_zone_name = data.terraform_remote_state.dns.outputs.public_zone_name
  cert_public_zone_id   = data.terraform_remote_state.dns.outputs.public_zone_id

  datadog_api_key        = data.terraform_remote_state.datadog.outputs.datadog_api_key
  datadog_logging_lambda = data.terraform_remote_state.datadog.outputs.datadog_lambda_arn
  datadog_env            = "vbr-${lower(var.environment_name)}"
}

