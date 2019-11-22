module "public-api" {
  source = "../public-api"

  region            = var.aws_region
  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  app            = "basisregisters"
  cpu            = 256
  memory         = 512
  min_instances  = 2
  max_instances  = 4
  image          = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/public-api/api-legacy:2.38.17"
  container_port = 2080

  extract_bundler_cpu      = 256
  extract_bundler_memory   = 512
  extract_bundler_schedule = "cron(0 22 * * ? *)"
  extract_bundler_enabled  = false
  extract_bundler_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/public-api/extract-bundler:1.1.1"

  lb_port     = 80
  lb_protocol = "TCP"

  ecs_sg_id = data.terraform_remote_state.fargate.outputs.fargate_security_group_id
  ecs_sg_ports = [
    "2080-2080",
  ]

  extracts_expiration_days = var.extracts_expiration_days

  task_execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn

  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_cidr_block  = data.terraform_remote_state.vpc.outputs.cidr_block
  public_subnets  = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  api_lb_arn      = module.api.lb_arn
  api_lb_dns_name = module.api.lb_dns_name
  api_lb_zone_id  = module.api.lb_zone_id

  disco_namespace_id = aws_service_discovery_private_dns_namespace.basisregisters.id
  disco_zone_name    = var.disco_zone_name
  alias_zone_name    = var.alias_zone_name
  public_zone_id     = data.terraform_remote_state.dns.outputs.public_zone_id
  public_zone_name   = data.terraform_remote_state.dns.outputs.public_zone_name
  private_zone_name  = data.terraform_remote_state.dns.outputs.private_zone_name

  datadog_api_key        = data.terraform_remote_state.datadog.outputs.datadog_api_key
  datadog_logging_lambda = data.terraform_remote_state.datadog.outputs.datadog_lambda_arn
  datadog_env            = "vbr-${lower(var.environment_name)}"

  fargate_cluster_name = data.terraform_remote_state.fargate.outputs.fargate_cluster_name
  fargate_cluster_id   = data.terraform_remote_state.fargate.outputs.fargate_cluster_id
  fargate_cluster_arn  = data.terraform_remote_state.fargate.outputs.fargate_cluster_arn

  docs_target_group_arn = module.docs.target_group_id
}
