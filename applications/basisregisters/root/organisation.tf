variable "organisation_password" {
}

variable "organisation_acm_host" {
}

variable "organisation_acm_cookie_name" {
}

variable "organisation_acm_client_id" {
}

variable "organisation_acm_client_secret" {
}

variable "organisation_acm_shared_signing_key" {
}

module "organisation-registry" {
  source = "../or/organisation"

  region            = var.aws_region
  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  app        = "basisregisters"
  port_range = 9000

  ecs_sg_id = data.terraform_remote_state.fargate.outputs.fargate_security_group_id
  ecs_sg_ports = [
    "9000-9007",
  ]

  db_server   = data.terraform_remote_state.sqlserver.outputs.address
  sa_user     = var.sql_username
  sa_pass     = var.sql_password
  db_password = var.organisation_password

  acm_host               = var.organisation_acm_host
  acm_cookie_name        = var.organisation_acm_cookie_name
  acm_client_id          = var.organisation_acm_client_id
  acm_client_secret      = var.organisation_acm_client_secret
  acm_shared_signing_key = var.organisation_acm_shared_signing_key

  ops_lb_arn          = module.ops-api.lb_arn
  ops_lb_listener_arn = module.ops-api.lb_listener_arn
  ops_cert_arn        = module.ops-api.cert_arn

  task_execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  task_security_group_id  = module.public-api.task_security_group_id

  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnets  = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  disco_namespace_id    = aws_service_discovery_private_dns_namespace.basisregisters.id
  disco_zone_name       = var.disco_zone_name
  public_zone_id        = data.terraform_remote_state.dns.outputs.public_zone_id
  public_zone_name      = data.terraform_remote_state.dns.outputs.public_zone_name
  private_zone_name     = data.terraform_remote_state.dns.outputs.private_zone_name
  cert_public_zone_name = data.terraform_remote_state.dns.outputs.public_zone_name
  cert_public_zone_id   = data.terraform_remote_state.dns.outputs.public_zone_id

  datadog_api_key        = data.terraform_remote_state.datadog.outputs.datadog_api_key
  datadog_logging_lambda = data.terraform_remote_state.datadog.outputs.datadog_lambda_arn
  datadog_env            = "vbr-${lower(var.environment_name)}"

  fargate_cluster_name = data.terraform_remote_state.fargate.outputs.fargate_cluster_name
  fargate_cluster_id   = data.terraform_remote_state.fargate.outputs.fargate_cluster_id
  fargate_cluster_arn  = data.terraform_remote_state.fargate.outputs.fargate_cluster_arn
}

variable "organisation_alias_zone_name" {
}

module "organisation-dns" {
  source = "../or/dns"

  region            = var.aws_region
  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  vpc_id           = data.terraform_remote_state.vpc.outputs.vpc_id
  public_zone_name = var.organisation_alias_zone_name
}
