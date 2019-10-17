resource "aws_route53_record" "txt_dmarc" {
  zone_id = var.public_zone_id
  name    = "_dmarc.${var.public_zone_name}"
  type    = "TXT"
  ttl     = "600"
  records = ["v=DMARC1; p=none; rua=mailto:${var.dmarc_rua};"]
}
