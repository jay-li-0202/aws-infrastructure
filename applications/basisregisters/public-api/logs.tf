resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/fargate/task/${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api"
  retention_in_days = 30

  tags {
    Name        = "Public Api // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_cloudwatch_log_stream" "app_log_stream" {
  name           = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api"
  log_group_name = "${aws_cloudwatch_log_group.app_log_group.name}"
}
