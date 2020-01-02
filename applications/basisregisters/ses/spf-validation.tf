resource "aws_route53_record" "spf_mail_from" {
  zone_id = var.public_zone_id
  name    = aws_ses_domain_mail_from.main.mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

resource "aws_route53_record" "txt_domain" {
  count   = var.create_spf_txt_records ? 1 : 0
  zone_id = var.public_zone_id
  name    = var.public_zone_name
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

resource "aws_route53_record" "spf_domain" {
  count   = var.create_spf_records ? 1 : 0
  zone_id = var.public_zone_id
  name    = var.public_zone_name
  type    = "SPF"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}
