variable "postal_password" {}

module "postal-registry" {
  source = "../grar/postal"

  region            = "${var.aws_region}"
  environment_label = "${var.environment_label}"
  environment_name  = "${var.environment_name}"

  tag_environment = "${var.tag_environment}"
  tag_product     = "${var.tag_product}"
  tag_program     = "${var.tag_program}"
  tag_contact     = "${var.tag_contact}"

  app        = "basisregisters"
  port_range = 3000

  api_cpu           = 256
  api_memory        = 512
  api_replicas      = 2
  legacy_api_image  = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/postal-registry/api-legacy:1.5.1"
  import_api_image  = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/postal-registry/api-crab-import:1.5.1"
  extract_api_image = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/postal-registry/api-extract:1.5.1"

  projections_cpu      = 256
  projections_memory   = 512
  projections_replicas = 1
  projections_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/postal-registry/projector:1.5.1"
  syndication_image    = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/postal-registry/projections-syndication:1.5.1"

  cache_cpu    = 256
  cache_memory = 512
  cache_image  = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/redis/redis-populator:1.3.0"
  cache_server = "${data.terraform_remote_state.cache.cache_endpoint}"

  db_server   = "${data.terraform_remote_state.sqlserver.address}"
  sa_user     = "${var.sql_username}"
  sa_pass     = "${var.sql_password}"
  db_password = "${var.postal_password}"

  ops_lb_arn          = "${module.ops-api.lb_arn}"
  ops_lb_listener_arn = "${module.ops-api.lb_listener_arn}"
  ops_cert_arn        = "${module.ops-api.cert_arn}"

  task_execution_role_arn = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  task_security_group_id  = "${module.public-api.task_security_group_id}"

  vpc_id          = "${data.terraform_remote_state.vpc.vpc_id}"
  private_subnets = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]

  disco_namespace_id = "${aws_service_discovery_private_dns_namespace.basisregisters.id}"
  disco_zone_name    = "${var.disco_zone_name}"
  public_zone_id     = "${data.terraform_remote_state.dns.public_zone_id}"
  public_zone_name   = "${data.terraform_remote_state.dns.public_zone_name}"

  datadog_api_key        = "${data.terraform_remote_state.datadog.datadog_api_key}"
  datadog_logging_lambda = "${data.terraform_remote_state.datadog.datadog_lambda_arn}"
  datadog_env            = "vbr-${lower(var.environment_name)}"

  fargate_cluster_id = "${data.terraform_remote_state.fargate.fargate_cluster_id}"
  fargate_cluster_arn = "${data.terraform_remote_state.fargate.fargate_cluster_arn}"
}
