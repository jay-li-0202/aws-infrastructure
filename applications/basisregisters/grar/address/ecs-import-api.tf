resource "aws_service_discovery_service" "import-api" {
  name = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-address-registry-import-api"

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

resource "aws_ecs_service" "import-api" {
  name            = "${var.app}-address-registry-import-api"
  cluster         = var.fargate_cluster_id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.import-api.arn
  desired_count   = 1

  network_configuration {
    security_groups = [var.task_security_group_id]
    subnets         = var.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.import.id
    container_name   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-address-registry-import-api-import"
    container_port   = var.port_range
  }

  service_registries {
    registry_arn = aws_service_discovery_service.import-api.arn
  }
}

resource "aws_ecs_task_definition" "import-api" {
  family                   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-address-registry-import-api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.import_api_cpu
  memory                   = var.import_api_memory
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = data.template_file.import-api.rendered

  tags = {
    Name        = "Address Registry Import Api // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "template_file" "import-api" {
  template = file("${path.module}/ecs-import-api.json.tpl")

  vars = {
    environment_name  = lower(replace(var.environment_name, " ", "-"))
    datadog_api_key   = var.datadog_api_key
    disco_namespace   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}"
    app_name          = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-address-registry-import-api"
    logging_name      = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-address-registry"
    import_api_image  = var.import_api_image
    legacy_api_image  = var.legacy_api_image
    extract_api_image = var.extract_api_image
    import_port       = var.port_range
    legacy_port       = var.port_range + 2
    extract_port      = var.port_range + 4
    region            = var.region
    datadog_env       = var.datadog_env
    tag_environment   = var.tag_environment
    tag_product       = var.tag_product
    tag_program       = var.tag_program
    tag_contact       = var.tag_contact
    alias_zone_name   = replace(var.alias_zone_name, "/[.]$/", "")
    public_zone_name  = replace(var.public_zone_name, "/[.]$/", "")
    db_server         = var.db_server
    db_name           = var.db_name
    db_user           = var.db_user
    db_pass           = var.db_password
  }
}
