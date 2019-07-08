module "public-api" {
  source = "../public-api"

  region            = "${var.aws_region}"
  environment_label = "${var.environment_label}"
  environment_name  = "${var.environment_name}"

  tag_environment = "${var.tag_environment}"
  tag_product     = "${var.tag_product}"
  tag_program     = "${var.tag_program}"
  tag_contact     = "${var.tag_contact}"

  app            = "basisregisters"
  cpu            = 256
  memory         = 512
  replicas       = 2
  image          = "${var.aws_account_id}.dkr.ecr.eu-west-1.amazonaws.com/public-api/api-legacy:2.24.1"
  container_port = 2080

  task_execution_role_arn = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  ecs_sg_id               = "${data.terraform_remote_state.fargate.fargate_security_group_id}"

  vpc_id          = "${data.terraform_remote_state.vpc.vpc_id}"
  public_subnets  = ["${data.terraform_remote_state.vpc.public_subnet_ids}"]
  private_subnets = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]

  disco_namespace_id    = "${aws_service_discovery_private_dns_namespace.basisregisters.id}"
  public_zone_id        = "${data.terraform_remote_state.dns.public_zone_id}"
  public_zone_name      = "${data.terraform_remote_state.dns.public_zone_name}"
  private_zone_name     = "${data.terraform_remote_state.dns.private_zone_name}"
  disco_zone_name       = "${var.disco_zone_name}"
  cert_public_zone_name = "${data.terraform_remote_state.dns.public_zone_name}"
  cert_public_zone_id   = "${data.terraform_remote_state.dns.public_zone_id}"

  datadog_api_key        = "${data.terraform_remote_state.datadog.datadog_api_key}"
  datadog_logging_lambda = "${data.terraform_remote_state.datadog.datadog_lambda_arn}"
  datadog_env            = "vbr-${lower(var.environment_name)}"

  fargate_cluster_id = "${data.terraform_remote_state.fargate.fargate_cluster_id}"
}
