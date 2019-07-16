resource "aws_ecs_task_definition" "cache" {
  family                   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-streetname-registry-cache"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "${var.cache_cpu}"
  memory                   = "${var.cache_memory}"
  execution_role_arn       = "${var.task_execution_role_arn}"

  // task_role_arn         = "${aws_iam_role.app_role.arn}"
  container_definitions = "${data.template_file.cache.rendered}"

  tags {
    Name        = "StreetName Registry Cache // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

data "template_file" "cache" {
  template = "${file("${path.module}/ecs-cache.json.tpl")}"

  vars {
    environment_name = "${lower(replace(var.environment_name, " ", "-"))}"
    datadog_api_key  = "${var.datadog_api_key}"
    disco_namespace  = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}"
    app_name         = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-streetname-registry-cache"
    logging_name     = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-streetname-registry"
    cache_image      = "${var.cache_image}"
    region           = "${var.region}"
    datadog_env      = "${var.datadog_env}"
    tag_environment  = "${var.tag_environment}"
    tag_product      = "${var.tag_product}"
    tag_program      = "${var.tag_program}"
    tag_contact      = "${var.tag_contact}"

    public_zone_name = "${replace(var.public_zone_name, "/[.]$/", "")}"
    disco_zone_name  = "${replace(var.disco_zone_name, "/[.]$/", "")}"

    redis_server = "${var.cache_server}"

    db_server = "${var.db_server}"
    db_name   = "${var.db_name}"
    db_user   = "${var.db_user}"
    db_pass   = "${var.db_password}"
  }
}

resource "aws_iam_role" "ecs_events" {
  name        = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-streetname-registry-ecs-events"
  description = "Allows Cloudwatch to execute Fargate Tasks."

  assume_role_policy = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
DOC

  tags {
    Name = "Cloudwatch Fargate Executor // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma = "${var.tag_program}"
    Contact = "${var.tag_contact}"
  }
}

resource "aws_iam_role_policy" "ecs_events_run_task_with_any_role" {
  name = "ecs_events_run_task_with_any_role"
  role = "${aws_iam_role.ecs_events.id}"

  policy = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.cache.arn, "/:\\d+$/", ":*")}"
        }
    ]
}
DOC
}

resource "aws_cloudwatch_event_rule" "cache" {
  name                = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-streetname-registry-cache"
  description         = "Run ${var.app}-${lower(replace(var.environment_name, " ", "-"))}-streetname-registry-cache task at a scheduled time (${var.cache_schedule_expression})"
  schedule_expression = "${var.cache_schedule_expression}"
}

resource "aws_cloudwatch_event_target" "cache" {
  target_id = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-streetname-registry-cache"
  rule      = "${aws_cloudwatch_event_rule.cache.name}"
  arn       = "${var.fargate_cluster_arn}"
  role_arn  = "${aws_iam_role.ecs_events.arn}"

  ecs_target {
    task_count          = "1"
    launch_type         = "FARGATE"
    task_definition_arn = "${aws_ecs_task_definition.cache.arn}"

    network_configuration {
      security_groups = ["${var.task_security_group_id}"]
      subnets         = ["${var.private_subnets}"]
    }
  }
}
