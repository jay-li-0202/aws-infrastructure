variable "site_version" {
}

variable "site_cpu" {
}

variable "site_memory" {
}

variable "site_min_instances" {
}

variable "site_max_instances" {
}

module "site" {
  source = "../site"

  region            = var.aws_region
  environment_label = var.environment_label
  environment_name  = var.environment_name

  tag_environment = var.tag_environment
  tag_product     = var.tag_product
  tag_program     = var.tag_program
  tag_contact     = var.tag_contact

  app = "basisregisters"

  site_version       = var.site_version
  site_cpu           = var.site_cpu
  site_memory        = var.site_memory
  site_min_instances = var.site_min_instances
  site_max_instances = var.site_max_instances
  site_image         = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/basisregisters/site:${var.site_version}"
  site_port          = 80

  ecs_sg_id = data.terraform_remote_state.fargate.outputs.fargate_security_group_id

  task_execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  task_security_group_id  = module.public-api.task_security_group_id

  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnets    = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  private_subnets   = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  admin_cidr_blocks = var.admin_cidr_blocks

  disco_namespace_id    = aws_service_discovery_private_dns_namespace.basisregisters.id
  public_zone_id        = data.terraform_remote_state.dns.outputs.public_zone_id
  public_zone_name      = data.terraform_remote_state.dns.outputs.public_zone_name
  cert_public_zone_name = data.terraform_remote_state.dns.outputs.public_zone_name
  cert_public_zone_id   = data.terraform_remote_state.dns.outputs.public_zone_id
  cert_alias_zone_name  = module.dns.public_zone_name
  cert_alias_zone_id    = module.dns.public_zone_id

  datadog_api_key        = data.terraform_remote_state.datadog.outputs.datadog_api_key
  datadog_logging_lambda = data.terraform_remote_state.datadog.outputs.datadog_lambda_arn
  datadog_env            = "vbr-${lower(var.environment_name)}"

  fargate_cluster_name = data.terraform_remote_state.fargate.outputs.fargate_cluster_name
  fargate_cluster_id   = data.terraform_remote_state.fargate.outputs.fargate_cluster_id
}
