resource "aws_iam_user" "bundler" {
  name          = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-extract-bundler"
  path          = "/"
  force_destroy = true

  tags = {
    Name        = "Public Api Extract Bundler // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_iam_user_policy_attachment" "bundler" {
  user       = aws_iam_user.bundler.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_access_key" "bundler" {
  user = aws_iam_user.bundler.name
}
