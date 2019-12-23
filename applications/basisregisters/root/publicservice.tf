variable "publicservice_password" {
}

variable "publicservice_registry_version" {
}

variable "publicservice_registry_ui_min_instances" {
}

variable "publicservice_registry_ui_cpu" {
}

variable "publicservice_registry_ui_memory" {
}

variable "publicservice_registry_api_cpu" {
}

variable "publicservice_registry_api_memory" {
}

variable "publicservice_registry_api_min_instances" {
}

variable "publicservice_registry_api_max_instances" {
}

variable "publicservice_registry_projections_cpu" {
}

variable "publicservice_registry_projections_memory" {
}

variable "publicservice_registry_cache_cpu" {
}

variable "publicservice_registry_cache_memory" {
}

variable "publicservice_registry_cache_enabled" {
}

variable "publicservice_registry_orafin_cpu" {
}

variable "publicservice_registry_orafin_memory" {
}

variable "publicservice_registry_orafin_enabled" {
}

variable "publicservice_orafin_ftp_host" {
}

variable "publicservice_orafin_ftp_user" {
}

variable "publicservice_orafin_ftp_password" {
}

variable "publicservice_acm_host" {
}

variable "publicservice_acm_cookie_name" {
}

variable "publicservice_acm_client_id" {
}

variable "publicservice_acm_client_secret" {
}

variable "publicservice_acm_shared_signing_key" {
}

module "publicservice-registry" {
  source = "../dvr/publicservice"

  region            = var.aws_region
  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  app        = "basisregisters"
  port_range = 8000

  ecs_sg_id = data.terraform_remote_state.fargate.outputs.fargate_security_group_id
  ecs_sg_ports = [
    "8000-8007",
  ]

  api_version       = var.publicservice_registry_version
  api_cpu           = var.publicservice_registry_api_cpu
  api_memory        = var.publicservice_registry_api_memory
  api_min_instances = var.publicservice_registry_api_min_instances
  api_max_instances = var.publicservice_registry_api_max_instances
  api_image         = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/public-service-registry/api:${var.publicservice_registry_version}"

  orafin_cpu          = var.publicservice_registry_orafin_cpu
  orafin_memory       = var.publicservice_registry_orafin_memory
  orafin_enabled      = var.publicservice_registry_orafin_enabled
  orafin_schedule     = "cron(0 20 * * ? *)" // Every day at 20:00
  orafin_image        = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/public-service-registry/batch-orafin:${var.publicservice_registry_version}"
  orafin_ftp_host     = var.publicservice_orafin_ftp_host
  orafin_ftp_user     = var.publicservice_orafin_ftp_user
  orafin_ftp_password = var.publicservice_orafin_ftp_password
  orafin_ftp_path     = "IN"

  projections_cpu           = var.publicservice_registry_projections_cpu
  projections_memory        = var.publicservice_registry_projections_memory
  projections_min_instances = 1
  projections_image         = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/public-service-registry/projector:${var.publicservice_registry_version}"

  ui_cpu           = var.publicservice_registry_ui_cpu
  ui_memory        = var.publicservice_registry_ui_memory
  ui_min_instances = var.publicservice_registry_ui_min_instances
  ui_image         = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/public-service-registry/ui:${var.publicservice_registry_version}"

  cache_cpu      = var.publicservice_registry_cache_cpu
  cache_memory   = var.publicservice_registry_cache_memory
  cache_enabled  = var.publicservice_registry_cache_enabled
  cache_schedule = "cron(0/5 * * * ? *)"
  cache_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/redis/redis-populator:1.7.1"
  cache_server   = data.terraform_remote_state.cache.outputs.cache_endpoint

  db_server   = data.terraform_remote_state.sqlserver.outputs.address
  sa_user     = var.sql_username
  sa_pass     = var.sql_password
  db_password = var.publicservice_password
  sql_port    = var.sql_ssh_port_forward

  acm_host               = var.publicservice_acm_host
  acm_cookie_name        = var.publicservice_acm_cookie_name
  acm_client_id          = var.publicservice_acm_client_id
  acm_client_secret      = var.publicservice_acm_client_secret
  acm_shared_signing_key = var.publicservice_acm_shared_signing_key

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
  alias_zone_name       = var.alias_zone_name
  public_zone_id        = data.terraform_remote_state.dns.outputs.public_zone_id
  public_zone_name      = data.terraform_remote_state.dns.outputs.public_zone_name
  private_zone_name     = data.terraform_remote_state.dns.outputs.private_zone_name
  cert_public_zone_name = data.terraform_remote_state.dns.outputs.public_zone_name
  cert_public_zone_id   = data.terraform_remote_state.dns.outputs.public_zone_id
  cert_alias_zone_name  = module.dns.public_zone_name
  cert_alias_zone_id    = module.dns.public_zone_id

  datadog_api_key        = data.terraform_remote_state.datadog.outputs.datadog_api_key
  datadog_logging_lambda = data.terraform_remote_state.datadog.outputs.datadog_lambda_arn
  datadog_env            = "vbr-${lower(var.environment_name)}"

  fargate_cluster_name = data.terraform_remote_state.fargate.outputs.fargate_cluster_name
  fargate_cluster_id   = data.terraform_remote_state.fargate.outputs.fargate_cluster_id
  fargate_cluster_arn  = data.terraform_remote_state.fargate.outputs.fargate_cluster_arn
}
