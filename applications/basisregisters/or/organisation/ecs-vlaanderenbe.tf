resource "aws_ecs_task_definition" "vlaanderenbe" {
  family                   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-vlaanderenbe"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.batch_vlaanderenbe_cpu
  memory                   = var.batch_vlaanderenbe_memory
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = data.template_file.vlaanderenbe.rendered

  tags = {
    Name        = "Organisation Registry Vlaanderenbe Notifier // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "template_file" "vlaanderenbe" {
  template = file("${path.module}/ecs-vlaanderenbe.json.tpl")

  vars = {
    environment_name   = lower(replace(var.environment_name, " ", "-"))
    datadog_api_key    = var.datadog_api_key
    disco_namespace    = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}"
    app_name           = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-vlaanderenbe"
    logging_name       = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry"
    vlaanderenbe_image = var.batch_vlaanderenbe_image
    region             = var.region
    datadog_env        = var.datadog_env
    tag_environment    = var.tag_environment
    tag_product        = var.tag_product
    tag_program        = var.tag_program
    tag_contact        = var.tag_contact
    public_zone_name   = replace(var.public_zone_name, "/[.]$/", "")
    disco_zone_name    = replace(var.disco_zone_name, "/[.]$/", "")
    db_server          = var.db_server
    db_name            = var.db_name
    db_user            = var.db_user
    db_pass            = var.db_password
    access_key         = aws_iam_access_key.mutex.id
    access_secret      = aws_iam_access_key.mutex.secret
  }
}

resource "aws_cloudwatch_event_rule" "vlaanderenbe" {
  name                = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-vlaanderenbe"
  description         = "Run ${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-vlaanderenbe task at a scheduled time (${var.batch_vlaanderenbe_schedule})"
  schedule_expression = var.batch_vlaanderenbe_schedule
  is_enabled          = var.batch_vlaanderenbe_enabled
}

resource "aws_cloudwatch_event_target" "vlaanderenbe" {
  target_id = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-vlaanderenbe"
  rule      = aws_cloudwatch_event_rule.vlaanderenbe.name
  arn       = var.fargate_cluster_arn
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    task_count          = "1"
    launch_type         = "FARGATE"
    task_definition_arn = aws_ecs_task_definition.vlaanderenbe.arn

    network_configuration {
      security_groups = [var.task_security_group_id]
      subnets         = var.private_subnets
    }
  }
}
