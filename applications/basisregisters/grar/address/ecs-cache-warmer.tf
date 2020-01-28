resource "aws_ecs_task_definition" "cache_warmer" {
  family                   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-address-registry-cache-warmer"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cache_warmer_cpu
  memory                   = var.cache_warmer_memory
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = data.template_file.cache_warmer.rendered

  tags = {
    Name        = "Address Registry Cache Warmer // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "template_file" "cache_warmer" {
  template = file("${path.module}/ecs-cache-warmer.json.tpl")

  vars = {
    environment_name  = lower(replace(var.environment_name, " ", "-"))
    datadog_api_key   = var.datadog_api_key
    disco_namespace   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}"
    app_name          = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-address-registry-cache-warmer"
    logging_name      = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-address-registry"
    cache_warmer_image   = var.cache_warmer_image
    region            = var.region
    datadog_env       = var.datadog_env
    tag_environment   = var.tag_environment
    tag_product       = var.tag_product
    tag_program       = var.tag_program
    tag_contact       = var.tag_contact
    public_zone_name  = replace(var.public_zone_name, "/[.]$/", "")
    disco_zone_name   = replace(var.disco_zone_name, "/[.]$/", "")
  }
}

resource "aws_cloudwatch_event_rule" "cache_warmer" {
  name                = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-address-registry-cache-warmer"
  description         = "Run ${var.app}-${lower(replace(var.environment_name, " ", "-"))}-address-registry-cache-warmer task at a scheduled time (${var.cache_warmer_schedule})"
  schedule_expression = var.cache_warmer_schedule
  is_enabled          = var.cache_warmer_enabled
}

resource "aws_cloudwatch_event_target" "cache_warmer" {
  target_id = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-address-registry-cache-warmer"
  rule      = aws_cloudwatch_event_rule.cache_warmer.name
  arn       = var.fargate_cluster_arn
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    task_count          = "1"
    launch_type         = "FARGATE"
    task_definition_arn = aws_ecs_task_definition.cache_warmer.arn

    network_configuration {
      security_groups = [var.task_security_group_id]
      subnets         = var.private_subnets
    }
  }
}
