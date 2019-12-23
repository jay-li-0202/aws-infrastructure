variable "municipality_password" {
}

variable "municipality_registry_version" {
}

variable "municipality_registry_api_cpu" {
}

variable "municipality_registry_api_memory" {
}

variable "municipality_registry_import_api_cpu" {
}

variable "municipality_registry_import_api_memory" {
}

variable "municipality_registry_api_min_instances" {
}

variable "municipality_registry_api_max_instances" {
}

variable "municipality_registry_projections_cpu" {
}

variable "municipality_registry_projections_memory" {
}

variable "municipality_registry_cache_cpu" {
}

variable "municipality_registry_cache_memory" {
}

variable "municipality_registry_cache_enabled" {
}

module "municipality-registry" {
  source = "../grar/municipality"

  region            = var.aws_region
  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  app        = "basisregisters"
  port_range = 2000

  api_cpu           = var.municipality_registry_api_cpu
  api_memory        = var.municipality_registry_api_memory
  import_api_cpu    = var.municipality_registry_import_api_cpu
  import_api_memory = var.municipality_registry_import_api_memory
  api_min_instances = var.municipality_registry_api_min_instances
  api_max_instances = var.municipality_registry_api_max_instances
  legacy_api_image  = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/municipality-registry/api-legacy:${var.municipality_registry_version}"
  import_api_image  = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/municipality-registry/api-crab-import:${var.municipality_registry_version}"
  extract_api_image = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/municipality-registry/api-extract:${var.municipality_registry_version}"

  projections_cpu           = var.municipality_registry_projections_cpu
  projections_memory        = var.municipality_registry_projections_memory
  projections_min_instances = 1
  projections_image         = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/municipality-registry/projector:${var.municipality_registry_version}"

  cache_cpu      = var.municipality_registry_cache_cpu
  cache_memory   = var.municipality_registry_cache_memory
  cache_enabled  = var.municipality_registry_cache_enabled
  cache_schedule = "cron(0/5 * * * ? *)"
  cache_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/redis/redis-populator:1.7.1"
  cache_server   = data.terraform_remote_state.cache.outputs.cache_endpoint

  db_server   = data.terraform_remote_state.sqlserver.outputs.address
  sa_user     = var.sql_username
  sa_pass     = var.sql_password
  db_password = var.municipality_password
  sql_port    = var.sql_ssh_port_forward

  ops_lb_arn          = module.ops-api.lb_arn
  ops_lb_listener_arn = module.ops-api.lb_listener_arn
  ops_cert_arn        = module.ops-api.cert_arn

  task_execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  task_security_group_id  = module.public-api.task_security_group_id

  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  disco_namespace_id = aws_service_discovery_private_dns_namespace.basisregisters.id
  disco_zone_name    = var.disco_zone_name
  alias_zone_name    = var.alias_zone_name
  public_zone_id     = data.terraform_remote_state.dns.outputs.public_zone_id
  public_zone_name   = data.terraform_remote_state.dns.outputs.public_zone_name

  datadog_api_key        = data.terraform_remote_state.datadog.outputs.datadog_api_key
  datadog_logging_lambda = data.terraform_remote_state.datadog.outputs.datadog_lambda_arn
  datadog_env            = "vbr-${lower(var.environment_name)}"

  fargate_cluster_name = data.terraform_remote_state.fargate.outputs.fargate_cluster_name
  fargate_cluster_id   = data.terraform_remote_state.fargate.outputs.fargate_cluster_id
  fargate_cluster_arn  = data.terraform_remote_state.fargate.outputs.fargate_cluster_arn
}
