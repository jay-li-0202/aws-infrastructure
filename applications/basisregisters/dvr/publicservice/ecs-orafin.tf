resource "aws_ecs_task_definition" "orafin" {
  family                   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry-orafin"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.orafin_cpu
  memory                   = var.orafin_memory
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = data.template_file.orafin.rendered

  tags = {
    Name        = "PublicService Registry Orafin // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "template_file" "orafin" {
  template = file("${path.module}/ecs-orafin.json.tpl")

  vars = {
    environment_name = lower(replace(var.environment_name, " ", "-"))
    datadog_api_key  = var.datadog_api_key
    disco_namespace  = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}"
    app_name         = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry-orafin"
    logging_name     = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry"
    orafin_image     = var.orafin_image
    region           = var.region
    datadog_env      = var.datadog_env
    tag_environment  = var.tag_environment
    tag_product      = var.tag_product
    tag_program      = var.tag_program
    tag_contact      = var.tag_contact
    public_zone_name = replace(var.public_zone_name, "/[.]$/", "")
    disco_zone_name  = replace(var.disco_zone_name, "/[.]$/", "")
    db_server        = var.db_server
    db_name          = var.db_name
    db_user          = var.db_user
    db_pass          = var.db_password

    orafin_ftp_host = var.orafin_ftp_host
    orafin_ftp_user = var.orafin_ftp_user
    orafin_ftp_password = var.orafin_ftp_password
    orafin_ftp_path = var.orafin_ftp_path
  }
}

resource "aws_cloudwatch_event_rule" "orafin" {
  name                = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry-orafin"
  description         = "Run ${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry-orafin task at a scheduled time (${var.orafin_schedule})"
  schedule_expression = var.orafin_schedule
  is_enabled          = var.orafin_enabled
}

resource "aws_cloudwatch_event_target" "orafin" {
  target_id = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry-orafin"
  rule      = aws_cloudwatch_event_rule.orafin.name
  arn       = var.fargate_cluster_arn
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    task_count          = "1"
    launch_type         = "FARGATE"
    task_definition_arn = aws_ecs_task_definition.orafin.arn

    network_configuration {
      security_groups = [var.task_security_group_id]
      subnets         = var.private_subnets
    }
  }
}
