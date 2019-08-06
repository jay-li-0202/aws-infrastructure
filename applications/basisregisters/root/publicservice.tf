variable "publicservice_password" {
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

  api_version = "1.7.3"
  api_cpu      = 512
  api_memory   = 1024
  api_replicas = 2
  api_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/public-service-registry/api:1.7.3"

  orafin_cpu      = 512
  orafin_memory   = 1024
  orafin_replicas = 1
  orafin_schedule = "cron(0/5 * * * ? *)"
  orafin_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/public-service-registry/batch-orafin:1.7.3"

  projections_cpu      = 512
  projections_memory   = 1024
  projections_replicas = 1
  projections_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/public-service-registry/projector:1.7.3"

  cache_cpu    = 512
  cache_memory = 1024
  cache_schedule = "cron(0/5 * * * ? *)"
  cache_image  = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/redis/redis-populator:1.3.0"
  cache_server = data.terraform_remote_state.cache.outputs.cache_endpoint

  ui_cpu      = 256
  ui_memory   = 512
  ui_replicas = 2
  ui_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/public-service-registry/ui:1.7.3"

  db_server   = data.terraform_remote_state.sqlserver.outputs.address
  sa_user     = var.sql_username
  sa_pass     = var.sql_password
  db_password = var.publicservice_password

  public_lb_listener_arn = module.public-api.lb_listener_arn

  ops_lb_arn          = module.ops-api.lb_arn
  ops_lb_listener_arn = module.ops-api.lb_listener_arn
  ops_cert_arn        = module.ops-api.cert_arn

  task_execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  task_security_group_id  = module.public-api.task_security_group_id

  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  disco_namespace_id = aws_service_discovery_private_dns_namespace.basisregisters.id
  disco_zone_name    = var.disco_zone_name
  public_zone_id     = data.terraform_remote_state.dns.outputs.public_zone_id
  public_zone_name   = data.terraform_remote_state.dns.outputs.public_zone_name

  datadog_api_key        = data.terraform_remote_state.datadog.outputs.datadog_api_key
  datadog_logging_lambda = data.terraform_remote_state.datadog.outputs.datadog_lambda_arn
  datadog_env            = "vbr-${lower(var.environment_name)}"

  fargate_cluster_id  = data.terraform_remote_state.fargate.outputs.fargate_cluster_id
  fargate_cluster_arn = data.terraform_remote_state.fargate.outputs.fargate_cluster_arn
}

