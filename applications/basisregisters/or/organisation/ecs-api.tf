resource "aws_service_discovery_service" "api" {
  name = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-api"

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

resource "aws_ecs_service" "api" {
  name        = "${var.app}-organisation-registry-api"
  cluster     = var.fargate_cluster_id
  launch_type = "FARGATE"
  // enable_ecs_managed_tags = true
  // propagate_tags = "TASK_DEFINITION"

  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = var.api_min_instances

  network_configuration {
    security_groups = [var.task_security_group_id]
    subnets         = var.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api.id
    container_name   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-api"
    container_port   = var.port_range + 2
  }

  service_registries {
    registry_arn = aws_service_discovery_service.api.arn
  }
}

resource "aws_ecs_task_definition" "api" {
  family                   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.api_cpu
  memory                   = var.api_memory
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = data.template_file.api.rendered

  tags = {
    Name        = "Organisation Registry Api // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "template_file" "api" {
  template = file("${path.module}/ecs-api.json.tpl")

  vars = {
    environment_name = lower(replace(var.environment_name, " ", "-"))
    datadog_api_key  = var.datadog_api_key
    disco_namespace  = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}"
    app_name         = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry-api"
    logging_name     = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-organisation-registry"
    api_image        = var.api_image
    api_port         = var.port_range + 2
    region           = var.region
    datadog_env      = var.datadog_env
    tag_environment  = var.tag_environment
    tag_product      = var.tag_product
    tag_program      = var.tag_program
    tag_contact      = var.tag_contact
    alias_zone_name  = replace(var.alias_zone_name, "/[.]$/", "")
    public_zone_name = replace(var.public_zone_name, "/[.]$/", "")
    db_server        = var.db_server
    db_name          = var.db_name
    db_user          = var.db_user
    db_pass          = var.db_password
    es_server        = var.elasticsearch_server

    acm_host               = var.acm_host
    acm_shared_signing_key = var.acm_shared_signing_key
    acm_cookie_name        = var.acm_cookie_name
    acm_client_id          = var.acm_client_id
    acm_client_secret      = var.acm_client_secret
  }
}
