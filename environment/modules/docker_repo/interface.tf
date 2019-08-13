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

variable "repository_names" {
  type = list(string)
}

output "repository_url" {
  value = [aws_ecr_repository.repo.*.repository_url]
}
