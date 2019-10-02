resource "aws_service_discovery_service" "site" {
  name = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-site"

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

resource "aws_ecs_service" "site" {
  name            = "${var.app}-site"
  cluster         = var.fargate_cluster_id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.site.arn
  desired_count   = var.site_min_instances

  network_configuration {
    security_groups = [var.task_security_group_id]
    subnets         = var.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.id
    container_name   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-site"
    container_port   = var.site_port
  }

  service_registries {
    registry_arn = aws_service_discovery_service.site.arn
  }
}

resource "aws_ecs_task_definition" "site" {
  family                   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-site"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.site_cpu
  memory                   = var.site_memory
  execution_role_arn       = var.task_execution_role_arn

  container_definitions = data.template_file.site.rendered

  tags = {
    Name        = "Site // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

data "template_file" "site" {
  template = file("${path.module}/ecs-site.json.tpl")

  vars = {
    environment_name = lower(replace(var.environment_name, " ", "-"))
    datadog_api_key  = var.datadog_api_key
    disco_namespace  = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}"
    app_name         = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}"
    logging_name     = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-site"
    site_version     = var.site_version
    site_image       = var.site_image
    site_port        = var.site_port
    region           = var.region
    datadog_env      = var.datadog_env
    tag_environment  = var.tag_environment
    tag_product      = var.tag_product
    tag_program      = var.tag_program
    tag_contact      = var.tag_contact
    public_zone_name = replace(var.public_zone_name, "/[.]$/", "")
  }
}

resource "aws_appautoscaling_target" "site" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.fargate_cluster_name}/${aws_ecs_service.site.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.site_max_instances
  min_capacity       = var.site_min_instances
}

resource "aws_cloudwatch_metric_alarm" "site_cpu_high" {
  alarm_name          = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-CPU-High-${var.ecs_as_cpu_high_threshold_per}-site"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_as_cpu_high_threshold_per

  dimensions = {
    ClusterName = var.fargate_cluster_name
    ServiceName = aws_ecs_service.site.name
  }

  alarm_actions = [aws_appautoscaling_policy.site_up.arn]

  tags = {
    Name        = "Site // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_cloudwatch_metric_alarm" "site_cpu_low" {
  alarm_name          = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-CPU-Low-${var.ecs_as_cpu_low_threshold_per}-site"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_as_cpu_low_threshold_per

  dimensions = {
    ClusterName = var.fargate_cluster_name
    ServiceName = aws_ecs_service.site.name
  }

  alarm_actions = [aws_appautoscaling_policy.site_down.arn]

  tags = {
    Name        = "Site // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_appautoscaling_policy" "site_up" {
  name               = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-site-scale-up"
  service_namespace  = aws_appautoscaling_target.site.service_namespace
  resource_id        = aws_appautoscaling_target.site.resource_id
  scalable_dimension = aws_appautoscaling_target.site.scalable_dimension

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

resource "aws_appautoscaling_policy" "site_down" {
  name               = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-site-scale-down"
  service_namespace  = aws_appautoscaling_target.site.service_namespace
  resource_id        = aws_appautoscaling_target.site.resource_id
  scalable_dimension = aws_appautoscaling_target.site.scalable_dimension

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
