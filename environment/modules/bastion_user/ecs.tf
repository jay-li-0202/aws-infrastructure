data "template_file" "bastion" {
  template = file("${path.module}/bastion.json.tpl")

  vars = {
    environment_name = var.environment_name
    app_name         = "${var.bastion_user}-${lower(replace(var.environment_name, " ", "-"))}-bastion"
    image            = var.image
    region           = var.region
    cpu              = "256"
    memory           = "512"
    port             = "22"
  }
}

resource "aws_ecs_task_definition" "bastion" {
  family                   = "${var.bastion_user}-${lower(replace(var.environment_name, " ", "-"))}-bastion"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.task_execution_role_arn

  // task_role_arn         = "${aws_iam_role.app_role.arn}"
  container_definitions = data.template_file.bastion.rendered

  tags = {
    Name        = "Bastion ${var.bastion_user} // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/ecs/task/${var.bastion_user}-${lower(replace(var.environment_name, " ", "-"))}-bastion"
  retention_in_days = 30

  tags = {
    Name        = "Bastion ${var.bastion_user} // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_cloudwatch_log_stream" "app_log_stream" {
  name           = "${var.bastion_user}-${lower(replace(var.environment_name, " ", "-"))}-bastion"
  log_group_name = aws_cloudwatch_log_group.app_log_group.name
}
