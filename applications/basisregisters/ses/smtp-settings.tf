resource "aws_iam_user" "smtp" {
  name = "smtp-${var.public_zone_name}"
  path = "/system/"
}

resource "aws_iam_access_key" "smtp" {
  user    = aws_iam_user.smtp.name
}

resource "aws_iam_user_policy" "smtp" {
  name = "${var.app}-${lower(replace(var.environment_name, " ", "-"))}-ses-smtp"
  user = aws_iam_user.smtp.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ses:SendRawEmail"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
