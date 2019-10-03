resource "aws_route53_zone" "public" {
  name          = var.public_zone_name
  comment       = "Public zone for Base Registries ${var.environment_label} ${var.environment_name}."
  force_destroy = true

  tags = {
    Name        = "Public Zone Base Registries // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

/*
@               A       52.174.235.29
@               TXT     vbr-prod-queryservice.azurewebsites.net
awverify        CNAME   awverify.vbr-prod-queryservice.azurewebsites.net
beta            CNAME   vbr-beta-mgmtsvc.azurewebsites.net
awverify.beta   CNAME   awverify.vbr-beta-mgmtsvc.azurewebsites.net
*/

resource "aws_route53_record" "root_a" {
  zone_id = aws_route53_zone.public.zone_id
  name    = var.public_zone_name
  type    = "A"
  ttl     = "60"
  records = ["52.174.235.29"]
}

resource "aws_route53_record" "root_txt" {
  zone_id = aws_route53_zone.public.zone_id
  name    = var.public_zone_name
  type    = "TXT"
  ttl     = "60"
  records = ["vbr-prod-queryservice.azurewebsites.net"]
}

resource "aws_route53_record" "awverify_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "awverify.${var.public_zone_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["awverify.vbr-prod-queryservice.azurewebsites.net"]
}

resource "aws_route53_record" "beta_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "beta.${var.public_zone_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["vbr-beta-mgmtsvc.azurewebsites.net"]
}

resource "aws_route53_record" "awverify_beta_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "awverify.beta.${var.public_zone_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["awverify.vbr-beta-mgmtsvc.azurewebsites.net"]
}

// The ones below are already part of the new architecture
// resource "aws_route53_record" "api_cname" {
//   zone_id = aws_route53_zone.public.zone_id
//   name    = "api.${var.public_zone_name}"
//   type    = "CNAME"
//   ttl     = "60"
//   records = ["${var.api_fqdn}"]
// }

resource "aws_route53_record" "docs_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "docs.${var.public_zone_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${var.docs_fqdn}"]
}

resource "aws_route53_record" "wms_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "wms.${var.public_zone_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${var.wms_db_fqdn}"]
}
