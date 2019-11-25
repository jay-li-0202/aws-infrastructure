variable "environment_label" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "tag_environment" {
  type = string
}

variable "tag_product" {
  type = string
}

variable "tag_program" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "tag_contact" {
  type = string
}

variable "bastion_sg_id" {
  type = string
}

output "cluster_id" {
  value = aws_ecs_cluster.basisregisters.id
}

output "cluster_arn" {
  value = aws_ecs_cluster.basisregisters.arn
}

output "cluster_name" {
  value = "basisregisters-${lower(replace(var.environment_name, " ", "-"))}"
}

output "execution_role_arn" {
  value = aws_iam_role.ecs-task.arn
}

output "ecs_security_group" {
  value = aws_security_group.task.arn
}

output "ecs_security_group_id" {
  value = aws_security_group.task.id
}
