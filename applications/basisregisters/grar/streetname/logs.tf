resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/ecs/task/${var.app}-${lower(replace(var.environment_name, " ", "-"))}-streetname-registry"
  retention_in_days = 30

  tags {
    Name        = "Streetname Registry // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_cloudwatch_log_stream" "app_log_stream" {
  name           = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-streetname-registry"
  log_group_name = "${aws_cloudwatch_log_group.app_log_group.name}"
}

resource "aws_cloudwatch_log_group" "monitoring_log_group" {
  name              = "/ecs/task/${var.app}-${lower(replace(var.environment_name, " ", "-"))}-streetname-registry-datadog"
  retention_in_days = 30

  tags {
    Name        = "Streetname Registry Datadog // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_cloudwatch_log_stream" "monitoring_log_stream" {
  name           = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-streetname-registry-datadog"
  log_group_name = "${aws_cloudwatch_log_group.monitoring_log_group.name}"
}

resource "aws_lambda_permission" "app_log" {
  statement_id  = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-streetname-registry"
  action        = "lambda:InvokeFunction"
  function_name = "${var.datadog_logging_lambda}"
  principal     = "logs.eu-west-1.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.app_log_group.arn}"
}

resource "aws_cloudwatch_log_subscription_filter" "app_logfilter" {
  name            = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-streetname-registry"
  log_group_name  = "${aws_cloudwatch_log_group.app_log_group.name}"
  destination_arn = "${var.datadog_logging_lambda}"
  filter_pattern  = ""
}
