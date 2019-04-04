data "aws_caller_identity" "current" {}

resource "aws_iam_user" "docker" {
  name          = "publish-docker"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_policy_attachment" "docker" {
  user       = "${aws_iam_user.docker.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_access_key" "docker" {
  user = "${aws_iam_user.docker.name}"
}
