resource "aws_ecs_task_definition" "extract-bundler" {
  family                   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-extract-bundler"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.extract_bundler_cpu
  memory                   = var.extract_bundler_memory
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = data.template_file.extract-bundler.rendered

  tags = {
    Name        = "Extract Bundler // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "template_file" "extract-bundler" {
  template = file("${path.module}/ecs-extract-bundler.json.tpl")

  vars = {
    environment_name = lower(replace(var.environment_name, " ", "-"))
    datadog_api_key  = var.datadog_api_key
    disco_namespace  = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}"
    app_name         = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-extract-bundler"
    logging_name     = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api"
    extract_bundler_image      = var.extract_bundler_image
    region           = var.region
    datadog_env      = var.datadog_env
    tag_environment  = var.tag_environment
    tag_product      = var.tag_product
    tag_program      = var.tag_program
    tag_contact      = var.tag_contact
    extract_bundler_bucket = aws_s3_bucket.extract.id
    public_zone_name = replace(var.public_zone_name, "/[.]$/", "")
    disco_zone_name  = replace(var.disco_zone_name, "/[.]$/", "")
  }
}

resource "aws_iam_role" "ecs_events" {
  name        = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-extract-bundler-ecs-events"
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

  tags = {
    Name        = "Cloudwatch Fargate Executor // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_iam_role_policy" "ecs_events_run_task_with_any_role" {
  name = "ecs_events_run_task_with_any_role"
  role = aws_iam_role.ecs_events.id

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
            "Resource": "${replace(aws_ecs_task_definition.extract-bundler.arn, "/:\\d+$/", ":*")}"
        }
    ]
}
DOC

}

resource "aws_cloudwatch_event_rule" "extract-bundler" {
  name                = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-extract-bundler"
  description         = "Run ${var.app}-${lower(replace(var.environment_name, " ", "-"))}-extract-bundler task at a scheduled time (${var.extract_bundler_schedule})"
  schedule_expression = var.extract_bundler_schedule
  is_enabled          = var.extract_bundler_enabled
}

resource "aws_cloudwatch_event_target" "extract-bundler" {
  target_id = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-extract-bundler"
  rule      = aws_cloudwatch_event_rule.extract-bundler.name
  arn       = var.fargate_cluster_arn
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    task_count          = "1"
    launch_type         = "FARGATE"
    task_definition_arn = aws_ecs_task_definition.extract-bundler.arn

    network_configuration {
      security_groups = [var.ecs_sg_id]
      subnets         = var.private_subnets
    }
  }
}
