resource "aws_iam_user" "mutex" {
  name          = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-building-mutex"
  path          = "/"
  force_destroy = true

  tags = {
    Name        = "Building Registry Mutex // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_iam_user_policy_attachment" "mutex" {
  user       = aws_iam_user.mutex.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_access_key" "mutex" {
  user = aws_iam_user.mutex.name
}
