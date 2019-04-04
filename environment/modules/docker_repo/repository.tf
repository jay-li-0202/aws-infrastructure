resource "aws_ecr_repository" "repo" {
  count = "${length(var.repository_names)}"

  name = "${element(var.repository_names, count.index)}"
}
