data "aws_caller_identity" "current" {
}

resource "aws_iam_user" "tf" {
  name          = "terraform"
  path          = "/"
  force_destroy = true

  tags = {
    Name        = "Terraform // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_iam_user_policy_attachment" "tfe_admin" {
  user       = aws_iam_user.tf.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "tf" {
  user = aws_iam_user.tf.name
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 16
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}

resource "aws_iam_account_alias" "alias" {
  account_alias = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}"
}
