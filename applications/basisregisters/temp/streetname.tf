variable "streetname_password" {}

module "streetname-registry" {
  source = "../grar/streetname"

  region            = "${var.aws_region}"
  environment_label = "${var.environment_label}"
  environment_name  = "${var.environment_name}"

  tag_environment = "${var.tag_environment}"
  tag_product     = "${var.tag_product}"
  tag_program     = "${var.tag_program}"
  tag_contact     = "${var.tag_contact}"

  app        = "basisregisters"
  port_range = 4000

  api_cpu           = 256
  api_memory        = 512
  api_replicas      = 2
  legacy_api_image  = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/streetname-registry/api-legacy:1.4.0"
  import_api_image  = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/streetname-registry/api-crab-import:1.4.0"
  extract_api_image = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/streetname-registry/api-extract:1.4.0"

  projections_cpu      = 256
  projections_memory   = 512
  projections_replicas = 1
  projections_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/streetname-registry/projector:1.4.0"
  syndication_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/streetname-registry/projections-syndication:1.4.0"

  db_server = "${data.terraform_remote_state.sqlserver.address}"
  sa_user  = "${var.sql_username}"
  sa_pass  = "${var.sql_password}"
  db_password = "${var.streetname_password}"

  task_execution_role_arn = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  task_security_group_id  = "${module.public-api.task_security_group_id}"

  vpc_id          = "${data.terraform_remote_state.vpc.vpc_id}"
  private_subnets = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]

  disco_namespace_id = "${aws_service_discovery_private_dns_namespace.basisregisters.id}"
  public_zone_name   = "${data.terraform_remote_state.dns.public_zone_name}"
  disco_zone_name    = "${var.disco_zone_name}"

  datadog_api_key        = "${data.terraform_remote_state.datadog.datadog_api_key}"
  datadog_logging_lambda = "${data.terraform_remote_state.datadog.datadog_lambda_arn}"
  datadog_env            = "vbr-${lower(var.environment_name)}"

  fargate_cluster_id = "${data.terraform_remote_state.fargate.fargate_cluster_id}"
}
