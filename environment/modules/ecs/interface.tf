variable "environment_label" {
  type = "string"
}

variable "environment_name" {
  type = "string"
}

variable "tag_environment" {
  type = "string"
}

variable "tag_product" {
  type = "string"
}

variable "tag_program" {
  type = "string"
}

variable "tag_contact" {
  type = "string"
}

output "cluster_id" {
  value = "${aws_ecs_cluster.basisregisters.id}"
}

output "cluster_arn" {
  value = "${aws_ecs_cluster.basisregisters.arn}"
}