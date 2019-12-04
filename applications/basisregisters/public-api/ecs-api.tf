resource "aws_service_discovery_service" "api" {
  name = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api"

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
  name            = "${var.app}-public-api"
  cluster         = var.fargate_cluster_id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = var.min_instances

  network_configuration {
    security_groups = [var.ecs_sg_id]
    subnets         = var.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api.id
    container_name   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api"
    container_port   = var.container_port
  }

  load_balancer {
    target_group_arn = var.docs_target_group_arn
    container_name   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api"
    container_port   = var.container_port
  }

  service_registries {
    registry_arn = aws_service_discovery_service.api.arn
  }

  # workaround for https://github.com/hashicorp/terraform/issues/12634
  depends_on = [
    aws_lb_listener.tcp,
  ]
}

resource "aws_ecs_task_definition" "api" {
  family                   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = data.template_file.api.rendered

  tags = {
    Name        = "Public Api // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "template_file" "api" {
  template = file("${path.module}/ecs-api.json.tpl")

  vars = {
    environment_name       = lower(replace(var.environment_name, " ", "-"))
    datadog_api_key        = var.datadog_api_key
    app_name               = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api"
    disco_namespace        = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}"
    image                  = var.image
    region                 = var.region
    port                   = var.container_port
    datadog_env            = var.datadog_env
    tag_environment        = var.tag_environment
    tag_product            = var.tag_product
    tag_program            = var.tag_program
    tag_contact            = var.tag_contact
    extract_bundler_bucket = aws_s3_bucket.extract.id
    alias_zone_name        = replace(var.alias_zone_name, "/[.]$/", "")
    public_zone_name       = replace(var.public_zone_name, "/[.]$/", "")
    private_zone_name      = replace(var.private_zone_name, "/[.]$/", "")
    disco_zone_name        = replace(var.disco_zone_name, "/[.]$/", "")

    municipality_registry_cache  = var.municipality_registry_public_api_cache
    postal_registry_cache        = var.postal_registry_public_api_cache
    streetname_registry_cache    = var.streetname_registry_public_api_cache
    address_registry_cache       = var.address_registry_public_api_cache
    building_registry_cache      = var.building_registry_public_api_cache
    parcel_registry_cache        = var.parcel_registry_public_api_cache
    publicservice_registry_cache = var.publicservice_registry_public_api_cache
    organisation_registry_cache  = var.organisation_registry_public_api_cache
  }
}

resource "aws_appautoscaling_target" "api" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.fargate_cluster_name}/${aws_ecs_service.api.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.max_instances
  min_capacity       = var.min_instances
}

resource "aws_cloudwatch_metric_alarm" "api_cpu_high" {
  alarm_name          = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-CPU-High-${var.ecs_as_cpu_high_threshold_per}-public-api-registry-api"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_as_cpu_high_threshold_per

  dimensions = {
    ClusterName = var.fargate_cluster_name
    ServiceName = aws_ecs_service.api.name
  }

  alarm_actions = [aws_appautoscaling_policy.api_up.arn]

  tags = {
    Name        = "Public Api // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_cloudwatch_metric_alarm" "api_cpu_low" {
  alarm_name          = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-CPU-Low-${var.ecs_as_cpu_low_threshold_per}-public-api-registry-api"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_as_cpu_low_threshold_per

  dimensions = {
    ClusterName = var.fargate_cluster_name
    ServiceName = aws_ecs_service.api.name
  }

  alarm_actions = [aws_appautoscaling_policy.api_down.arn]

  tags = {
    Name        = "Public Api // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_appautoscaling_policy" "api_up" {
  name               = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api-registry-api-scale-up"
  service_namespace  = aws_appautoscaling_target.api.service_namespace
  resource_id        = aws_appautoscaling_target.api.resource_id
  scalable_dimension = aws_appautoscaling_target.api.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "api_down" {
  name               = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api-registry-api-scale-down"
  service_namespace  = aws_appautoscaling_target.api.service_namespace
  resource_id        = aws_appautoscaling_target.api.resource_id
  scalable_dimension = aws_appautoscaling_target.api.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}
