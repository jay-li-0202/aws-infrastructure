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

variable "tag_contact" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "log_group_retention_in_days" {
  type = string
}

variable "elasticsearch_version" {
  type = string
}

variable "data_instance_type" {
  type    = string
  default = "t2.medium.elasticsearch"
}

variable "data_instance_count" {
  type    = string
  default = "1"
}

variable "master_enabled" {
  type    = string
  default = "false"
}

variable "master_instance_type" {
  type    = string
  default = "t2.small.elasticsearch"
}

variable "master_instance_count" {
  type    = string
  default = "1"
}

variable "volume_type" {
  type    = string
  default = "gp2"
}

variable "volume_size" {
  type    = string
  default = "10"
}

variable "subnet_ids" {
  type = list(string)
}

variable "private_zone_id" {
  type = string
}

output "endpoint" {
  value = aws_elasticsearch_domain.es.endpoint
}

output "kibana_endpoint" {
  value = aws_elasticsearch_domain.es.kibana_endpoint
}
