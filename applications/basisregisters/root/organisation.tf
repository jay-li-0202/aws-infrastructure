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

variable "organisation_password" {
}

variable "organisation_registry_version" {
}

variable "organisation_registry_ui_min_instances" {
}

variable "organisation_registry_ui_cpu" {
}

variable "organisation_registry_ui_memory" {
}

variable "organisation_registry_api_cpu" {
}

variable "organisation_registry_api_memory" {
}

variable "organisation_registry_api_min_instances" {
}

variable "organisation_registry_api_max_instances" {
}

variable "organisation_registry_batch_agentschapzorgengezondheidftpdump_cpu" {
}

variable "organisation_registry_batch_agentschapzorgengezondheidftpdump_memory" {
}

variable "organisation_registry_batch_agentschapzorgengezondheidftpdump_enabled" {
}

variable "organisation_registry_batch_vlaanderenbe_cpu" {
}

variable "organisation_registry_batch_vlaanderenbe_memory" {
}

variable "organisation_registry_batch_vlaanderenbe_enabled" {
}

variable "organisation_registry_projections_elasticsearch_cpu" {
}

variable "organisation_registry_projections_elasticsearch_memory" {
}

variable "organisation_registry_projections_elasticsearch_enabled" {
}

variable "organisation_registry_projections_delegations_cpu" {
}

variable "organisation_registry_projections_delegations_memory" {
}

variable "organisation_registry_projections_delegations_enabled" {
}

variable "organisation_registry_projections_reporting_cpu" {
}

variable "organisation_registry_projections_reporting_memory" {
}

variable "organisation_registry_projections_reporting_enabled" {
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

  api_version       = var.organisation_registry_version
  api_cpu           = var.organisation_registry_api_cpu
  api_memory        = var.organisation_registry_api_memory
  api_min_instances = var.organisation_registry_api_min_instances
  api_max_instances = var.organisation_registry_api_max_instances
  api_image         = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/organisation-registry/api:${var.organisation_registry_version}"

  ui_cpu           = var.organisation_registry_ui_cpu
  ui_memory        = var.organisation_registry_ui_memory
  ui_min_instances = var.organisation_registry_ui_min_instances
  ui_image         = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/organisation-registry/ui:${var.organisation_registry_version}"

  batch_agentschapzorgengezondheidftpdump_cpu      = var.organisation_registry_batch_agentschapzorgengezondheidftpdump_cpu
  batch_agentschapzorgengezondheidftpdump_memory   = var.organisation_registry_batch_agentschapzorgengezondheidftpdump_memory
  batch_agentschapzorgengezondheidftpdump_enabled  = var.organisation_registry_batch_agentschapzorgengezondheidftpdump_enabled
  batch_agentschapzorgengezondheidftpdump_schedule = "cron(30 3 * * ? *)" // Every day at 3:30
  batch_agentschapzorgengezondheidftpdump_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/organisation-registry/batch-agentschapzorgengezondheidftpdump:${var.organisation_registry_version}"

  batch_vlaanderenbe_cpu      = var.organisation_registry_batch_vlaanderenbe_cpu
  batch_vlaanderenbe_memory   = var.organisation_registry_batch_vlaanderenbe_memory
  batch_vlaanderenbe_enabled  = var.organisation_registry_batch_vlaanderenbe_enabled
  batch_vlaanderenbe_schedule = "cron(0/30 * * * ? *)" // Every 30 minutes
  batch_vlaanderenbe_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/organisation-registry/batch-vlaanderenbe:${var.organisation_registry_version}"

  projections_elasticsearch_cpu      = var.organisation_registry_projections_elasticsearch_cpu
  projections_elasticsearch_memory   = var.organisation_registry_projections_elasticsearch_memory
  projections_elasticsearch_enabled  = var.organisation_registry_projections_elasticsearch_enabled
  projections_elasticsearch_schedule = "cron(0/5 * * * ? *)" // Every 5 minutes
  projections_elasticsearch_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/organisation-registry/projections-elasticsearch:${var.organisation_registry_version}"

  projections_delegations_cpu      = var.organisation_registry_projections_delegations_cpu
  projections_delegations_memory   = var.organisation_registry_projections_delegations_memory
  projections_delegations_enabled  = var.organisation_registry_projections_delegations_enabled
  projections_delegations_schedule = "cron(0/2 * * * ? *)" // Every 2 minutes
  projections_delegations_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/organisation-registry/projections-delegations:${var.organisation_registry_version}"

  projections_reporting_cpu      = var.organisation_registry_projections_reporting_cpu
  projections_reporting_memory   = var.organisation_registry_projections_reporting_memory
  projections_reporting_enabled  = var.organisation_registry_projections_reporting_enabled
  projections_reporting_schedule = "cron(0/2 * * * ? *)" // Every 2 minutes
  projections_reporting_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/organisation-registry/projections-reporting:${var.organisation_registry_version}"

  db_server   = data.terraform_remote_state.sqlserver.outputs.address
  sa_user     = var.sql_username
  sa_pass     = var.sql_password
  db_password = var.organisation_password

  elasticsearch_server = data.terraform_remote_state.elasticsearch.outputs.es_endpoint

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
