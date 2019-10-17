resource "aws_ses_domain_identity" "main" {
  domain = local.stripped_domain_name
}

resource "aws_ses_domain_identity_verification" "main" {
  count = "${var.enable_verification ? 1 : 0}"

  domain = aws_ses_domain_identity.main.id

  depends_on = ["aws_route53_record.ses_verification"]
}

resource "aws_route53_record" "ses_verification" {
  zone_id = var.public_zone_id
  name    = "_amazonses.${aws_ses_domain_identity.main.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.main.verification_token]
}
