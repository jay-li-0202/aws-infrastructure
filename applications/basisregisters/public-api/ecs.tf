data "template_file" "app" {
  template = "${file("${path.module}/app.json.tpl")}"

  vars {
    environment_name = "${var.environment_name}"
    app_name         = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api"
    image            = "${var.image}"
    cpu              = "${var.cpu}"
    memory           = "${var.memory}"
    region           = "${var.region}"
    port             = "${var.container_port}"

    public_zone_name  = "${replace(var.public_zone_name, "/[.]$/", "")}"
    private_zone_name = "${replace(var.private_zone_name, "/[.]$/", "")}"
    disco_zone_name   = "${replace(var.public_zone_name, "/[.]$/", "")}"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "${var.cpu}"
  memory                   = "${var.memory}"
  execution_role_arn       = "${var.task_execution_role_arn}"

  // task_role_arn         = "${aws_iam_role.app_role.arn}"
  container_definitions = "${data.template_file.app.rendered}"

  tags {
    Name        = "Public Api // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_ecs_service" "main" {
  name            = "${var.app}-public-api"
  cluster         = "${var.fargate_cluster_id}"
  launch_type     = "FARGATE"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = "${var.replicas}"

  network_configuration {
    security_groups = ["${aws_security_group.task.id}"]
    subnets         = ["${var.private_subnets}"]
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.main.id}"
    container_name   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-public-api"
    container_port   = "${var.container_port}"
  }

  service_registries {
    registry_arn = "${var.service_registry_arn}"
  }

  # workaround for https://github.com/hashicorp/terraform/issues/12634
  depends_on = [
    "aws_lb_listener.http",
    "aws_lb_listener.https"
  ]

  # [after initial apply] don't override changes made to task_definition
  # from outside of terraform (i.e.; fargate cli)
  // lifecycle {
  //   ignore_changes = ["task_definition"]
  // }
}
