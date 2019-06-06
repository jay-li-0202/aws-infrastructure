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

variable "domain_name" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "redis_cluster_id" {
  type    = "string"
  default = "redis-cluster"
}

variable "redis_version" {
  type = "string"
}

variable "redis_port" {
  type    = "string"
  default = 6379
}

variable "redis_snapshot_retention_limit" {
  type    = "string"
  default = 7
}

variable "redis_snapshot_window" {
  type    = "string"
  default = "03:00-05:00"
}

variable "redis_maintenance_window" {
  type    = "string"
  default = "Sun:00:00-Sun:02:00"
}

variable "redis_parameter_group" {
  type = "string"
}

variable "node_instance_type" {
  type = "string"
}

variable "node_instance_count" {
  type = "string"
}

variable "bastion_sg_id" {
  type = "string"
}

variable "ecs_sg_id" {
  type = "string"
}

variable "subnet_ids" {
  type = "list"
}

variable "private_zone_id" {
  type = "string"
}

output "endpoint" {
  value = "${aws_elasticache_replication_group.elasticache.configuration_endpoint_address}"
}
