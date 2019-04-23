resource "aws_ecs_service" "api" {
  name            = "${var.app}-municipality-registry-api"
  cluster         = "${var.fargate_cluster_id}"
  launch_type     = "FARGATE"
  task_definition = "${aws_ecs_task_definition.api.arn}"
  desired_count   = "${var.api_replicas}"

  network_configuration {
    security_groups = ["${var.task_security_group_id}"]
    subnets         = ["${var.private_subnets}"]
  }

  service_registries {
    registry_arn = "${var.service_registry_arn}"
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
  family                   = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-municipality-registry-api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "${var.api_cpu}"
  memory                   = "${var.api_memory}"
  execution_role_arn       = "${var.task_execution_role_arn}"

  // task_role_arn         = "${aws_iam_role.app_role.arn}"
  container_definitions = "${data.template_file.api.rendered}"

  tags {
    Name        = "Municipality Registry Api // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

data "template_file" "api" {
  template = "${file("${path.module}/ecs-api.json.tpl")}"

  vars {
    environment_name  = "${var.environment_name}"
    datadog_api_key   = "${var.datadog_api_key}"
    app_name          = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-municipality-registry-api"
    logging_name      = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-municipality-registry"
    import_api_image = "${var.import_api_image}"
    legacy_api_image = "${var.legacy_api_image}"
    extract_api_image = "${var.extract_api_image}"
    import_port  = "${var.port_range}"
    legacy_port  = "${var.port_range + 2}"
    extract_port  = "${var.port_range + 4}"
    region            = "${var.region}"
    datadog_env       = "${var.datadog_env}"
    tag_environment   = "${var.tag_environment}"
    tag_product       = "${var.tag_product}"
    tag_program       = "${var.tag_program}"
    tag_contact       = "${var.tag_contact}"

    // public_zone_name  = "${replace(var.public_zone_name, "/[.]$/", "")}"
    // private_zone_name = "${replace(var.private_zone_name, "/[.]$/", "")}"
    // disco_zone_name   = "${replace(var.disco_zone_name, "/[.]$/", "")}"
  }
}
