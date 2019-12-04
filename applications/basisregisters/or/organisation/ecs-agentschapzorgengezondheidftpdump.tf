resource "aws_ecs_task_definition" "agentschapzorgengezondheidftpdump" {
  family                   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-zorgengezondheid"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.batch_agentschapzorgengezondheidftpdump_cpu
  memory                   = var.batch_agentschapzorgengezondheidftpdump_memory
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = data.template_file.agentschapzorgengezondheidftpdump.rendered

  tags = {
    Name        = "Organisation Registry Agentschap Zorg en Gezondheid FTP Dump // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "template_file" "agentschapzorgengezondheidftpdump" {
  template = file("${path.module}/ecs-agentschapzorgengezondheidftpdump.json.tpl")

  vars = {
    environment_name                        = lower(replace(var.environment_name, " ", "-"))
    datadog_api_key                         = var.datadog_api_key
    disco_namespace                         = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}"
    app_name                                = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-zorgengezondheid"
    logging_name                            = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry"
    agentschapzorgengezondheidftpdump_image = var.batch_agentschapzorgengezondheidftpdump_image
    region                                  = var.region
    datadog_env                             = var.datadog_env
    tag_environment                         = var.tag_environment
    tag_product                             = var.tag_product
    tag_program                             = var.tag_program
    tag_contact                             = var.tag_contact
    public_zone_name                        = replace(var.public_zone_name, "/[.]$/", "")
    disco_zone_name                         = replace(var.disco_zone_name, "/[.]$/", "")
    db_server                               = var.db_server
    db_name                                 = var.db_name
    db_user                                 = var.db_user
    db_pass                                 = var.db_password
    ftp_host                                = var.batch_agentschapzorgengezondheidftpdump_ftp_host
    ftp_user                                = var.batch_agentschapzorgengezondheidftpdump_ftp_user
    ftp_password                            = var.batch_agentschapzorgengezondheidftpdump_ftp_password
  }
}

resource "aws_cloudwatch_event_rule" "agentschapzorgengezondheidftpdump" {
  name                = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-zorgengezondheid"
  description         = "Run ${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-zorgengezondheid task at a scheduled time (${var.batch_agentschapzorgengezondheidftpdump_schedule})"
  schedule_expression = var.batch_agentschapzorgengezondheidftpdump_schedule
  is_enabled          = var.batch_agentschapzorgengezondheidftpdump_enabled
}

resource "aws_cloudwatch_event_target" "agentschapzorgengezondheidftpdump" {
  target_id = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-zorgengezondheid"
  rule      = aws_cloudwatch_event_rule.agentschapzorgengezondheidftpdump.name
  arn       = var.fargate_cluster_arn
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    task_count          = "1"
    launch_type         = "FARGATE"
    task_definition_arn = aws_ecs_task_definition.agentschapzorgengezondheidftpdump.arn

    network_configuration {
      security_groups = [var.task_security_group_id]
      subnets         = var.private_subnets
    }
  }
}
