resource "aws_service_discovery_service" "api" {
  name = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry-api"

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
  name            = "${var.app}-publicservice-registry-api"
  cluster         = var.fargate_cluster_id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = var.api_min_instances

  network_configuration {
    security_groups = [var.task_security_group_id]
    subnets         = var.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api.id
    container_name   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry-api"
    container_port   = var.port_range + 2
  }

  service_registries {
    registry_arn = aws_service_discovery_service.api.arn
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

resource "aws_ecs_task_definition" "api" {
  family                   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry-api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.api_cpu
  memory                   = var.api_memory
  execution_role_arn       = var.task_execution_role_arn

  // task_role_arn         = "${aws_iam_role.app_role.arn}"
  container_definitions = data.template_file.api.rendered

  tags = {
    Name        = "PublicService Registry Api // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "template_file" "api" {
  template = file("${path.module}/ecs-api.json.tpl")

  vars = {
    environment_name  = lower(replace(var.environment_name, " ", "-"))
    datadog_api_key   = var.datadog_api_key
    disco_namespace   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}"
    app_name          = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry-api"
    logging_name      = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry"
    api_image         = var.api_image
    api_port          = var.port_range + 2
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

resource "aws_appautoscaling_target" "api" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.fargate_cluster_name}/${aws_ecs_service.api.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.api_max_instances
  min_capacity       = var.api_min_instances
}

resource "aws_cloudwatch_metric_alarm" "api_cpu_high" {
  alarm_name          = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-CPU-High-${var.ecs_as_cpu_high_threshold_per}-publicservice-registry-api"
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
}

resource "aws_cloudwatch_metric_alarm" "api_cpu_low" {
  alarm_name          = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-CPU-Low-${var.ecs_as_cpu_low_threshold_per}-publicservice-registry-api"
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
}

resource "aws_appautoscaling_policy" "api_up" {
  name               = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry-api-scale-up"
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
  name               = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-publicservice-registry-api-scale-down"
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
