# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "basisregisters-${lower(replace(var.environment_name, " ", "-"))}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_service_discovery_private_dns_namespace" "basisregisters" {
  name        = "${var.disco_zone_name}"
  description = "Basisregisters Vlaanderen Service Discovery"
  vpc         = "${data.terraform_remote_state.vpc.vpc_id}"
}

resource "aws_service_discovery_service" "basisregisters" {
  name = "basisregisters-${lower(replace(var.environment_name, " ", "-"))}"

  health_check_custom_config {
    failure_threshold = 1
  }

  dns_config {
    namespace_id = "${aws_service_discovery_private_dns_namespace.basisregisters.id}"

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }
}
