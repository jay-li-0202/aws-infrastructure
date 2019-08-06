resource "aws_service_discovery_service" "ui" {
  name = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry-ui"

  health_check_custom_config {
    failure_threshold = 1
  }

  dns_config {
    namespace_id = var.disco_namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }
}

resource "aws_ecs_service" "ui" {
  name            = "${var.app}-publicservice-registry-ui"
  cluster         = var.fargate_cluster_id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.ui.arn
  desired_count   = var.ui_replicas

  network_configuration {
    security_groups = [var.task_security_group_id]
    subnets         = var.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ui.id
    container_name   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry-ui"
    container_port   = var.port_range + 7
  }

  service_registries {
    registry_arn = aws_service_discovery_service.ui.arn
  }

  // ordered_placement_strategy {
  //   type   = "spread"
  //   field  = "attribute:ecs.availability-zone"
  // }

  // ordered_placement_strategy {
  //   type   = "spread"
  //   field  = "instanceId"
  // }

  # [after initial apply] don't override changes made to task_definition
  # from outside of terraform (i.e.; fargate cli)
  // lifecycle {
  //   ignore_changes = ["task_definition"]
  // }
}

resource "aws_ecs_task_definition" "ui" {
  family                   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry-ui"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ui_cpu
  memory                   = var.ui_memory
  execution_role_arn       = var.task_execution_role_arn

  // task_role_arn         = "${aws_iam_role.app_role.arn}"
  container_definitions = data.template_file.ui.rendered

  tags = {
    Name        = "PublicService Registry UI // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "template_file" "ui" {
  template = file("${path.module}/ecs-ui.json.tpl")

  vars = {
    environment_name  = lower(replace(var.environment_name, " ", "-"))
    datadog_ui_key    = var.datadog_ui_key
    disco_namespace   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}"
    app_name          = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry-ui"
    logging_name      = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry"
    api_version       = var.api_version
    ui_image          = var.ui_image
    ui_port           = var.port_range + 7
    region            = var.region
    datadog_env       = var.datadog_env
    tag_environment   = var.tag_environment
    tag_product       = var.tag_product
    tag_program       = var.tag_program
    tag_contact       = var.tag_contact
    public_zone_name  = replace(var.public_zone_name, "/[.]$/", "")
    db_server         = var.db_server
    db_name           = var.db_name
    db_user           = var.db_user
    db_pass           = var.db_password
  }
}

