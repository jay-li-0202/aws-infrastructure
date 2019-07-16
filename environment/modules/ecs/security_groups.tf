resource "aws_security_group" "task" {
  name        = "${lower(replace(var.environment_name, " ", "-"))}-task"
  description = "Security group for ECS Task"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Name        = "ECS Task // ${var.environment_label} ${var.environment_name}"
    Environment = "${var.tag_environment}"
    Productcode = "${var.tag_product}"
    Programma   = "${var.tag_program}"
    Contact     = "${var.tag_contact}"
  }
}

resource "aws_security_group_rule" "task_egress_rule" {
  description = "Task outgoing"
  type        = "egress"
  from_port   = "0"
  to_port     = "0"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.task.id}"
}
