resource "aws_ecs_task_definition" "elasticsearch" {
  family                   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-elasticsearch"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.projections_elasticsearch_cpu
  memory                   = var.projections_elasticsearch_memory
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = data.template_file.elasticsearch.rendered

  tags = {
    Name        = "Organisation Registry Elasticsearch Projections // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "template_file" "elasticsearch" {
  template = file("${path.module}/ecs-elasticsearch.json.tpl")

  vars = {
    environment_name    = lower(replace(var.environment_name, " ", "-"))
    datadog_api_key     = var.datadog_api_key
    disco_namespace     = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}"
    app_name            = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-elasticsearch"
    logging_name        = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry"
    elasticsearch_image = var.projections_elasticsearch_image
    region              = var.region
    datadog_env         = var.datadog_env
    tag_environment     = var.tag_environment
    tag_product         = var.tag_product
    tag_program         = var.tag_program
    tag_contact         = var.tag_contact
    public_zone_name    = replace(var.public_zone_name, "/[.]$/", "")
    disco_zone_name     = replace(var.disco_zone_name, "/[.]$/", "")
    db_server           = var.db_server
    db_name             = var.db_name
    db_user             = var.db_user
    db_pass             = var.db_password
  }
}

resource "aws_cloudwatch_event_rule" "elasticsearch" {
  name                = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-elasticsearch"
  description         = "Run ${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-elasticsearch task at a scheduled time (${var.projections_elasticsearch_schedule})"
  schedule_expression = var.projections_elasticsearch_schedule
  is_enabled          = var.projections_elasticsearch_enabled
}

resource "aws_cloudwatch_event_target" "elasticsearch" {
  target_id = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-elasticsearch"
  rule      = aws_cloudwatch_event_rule.elasticsearch.name
  arn       = var.fargate_cluster_arn
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    task_count          = "1"
    launch_type         = "FARGATE"
    task_definition_arn = aws_ecs_task_definition.elasticsearch.arn

    network_configuration {
      security_groups = [var.task_security_group_id]
      subnets         = var.private_subnets
    }
  }
}
