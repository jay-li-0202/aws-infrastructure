output "docker_user_name" {
  value = "${aws_iam_user.docker.name}"
}

output "docker_user_key" {
  value = "${aws_iam_access_key.docker.id}"
}

output "docker_user_secret" {
  value = "${aws_iam_access_key.docker.secret}"
}
