variable "aws_region" {}
variable "aws_profile" {}
variable "aws_account_id" {}

variable "environment_label" {}
variable "environment_name" {}

variable "tag_environment" {}
variable "tag_product" {}
variable "tag_program" {}
variable "tag_contact" {}

variable "state_bucket" {}

variable "disco_zone_name" {
  type    = "string"
  default = "basisregisters.disco"
}

provider "aws" {
  version             = "~> 2.4.0"
  region              = "${var.aws_region}"
  profile             = "${var.aws_profile}"
  allowed_account_ids = ["${var.aws_account_id}"]
}

terraform {
  backend "s3" {
    key = "app-basisregisters/terraform.tfstate"
  }
}

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
  image          = "921707234258.dkr.ecr.eu-west-1.amazonaws.com/public-api/api-legacy:2.10.2"
  container_port = 2080

  task_execution_role_arn = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  service_registry_arn    = "${aws_service_discovery_service.basisregisters.arn}"

  vpc_id          = "${data.terraform_remote_state.vpc.vpc_id}"
  public_subnets  = ["${data.terraform_remote_state.vpc.public_subnet_ids}"]
  private_subnets = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]

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

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket  = "${var.state_bucket}"
    region  = "${var.aws_region}"
    key     = "vpc/terraform.tfstate"
    profile = "${var.aws_profile}"
  }
}

data "terraform_remote_state" "dns" {
  backend = "s3"

  config {
    bucket  = "${var.state_bucket}"
    region  = "${var.aws_region}"
    key     = "dns/terraform.tfstate"
    profile = "${var.aws_profile}"
  }
}

data "terraform_remote_state" "fargate" {
  backend = "s3"

  config {
    bucket  = "${var.state_bucket}"
    region  = "${var.aws_region}"
    key     = "fargate/terraform.tfstate"
    profile = "${var.aws_profile}"
  }
}

data "terraform_remote_state" "datadog" {
  backend = "s3"

  config {
    bucket  = "${var.state_bucket}"
    region  = "${var.aws_region}"
    key     = "datadog_aws/terraform.tfstate"
    profile = "${var.aws_profile}"
  }
}

// output "vpc_id" {
//   value = "${module.vpc.vpc_id}"
// }

