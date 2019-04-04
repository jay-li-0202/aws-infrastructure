variable "repository_names" {
  type = "list"
}

output "repository_url" {
  value = ["${aws_ecr_repository.repo.*.repository_url}"]
}
