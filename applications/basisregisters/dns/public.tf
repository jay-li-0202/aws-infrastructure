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
  records = concat(["vbr-prod-queryservice.azurewebsites.net"], var.root_txt_records)
}

resource "aws_route53_record" "awverify_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "awverify"
  type    = "CNAME"
  ttl     = "60"
  records = ["awverify.vbr-prod-queryservice.azurewebsites.net"]
}

resource "aws_route53_record" "beta_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "beta"
  type    = "CNAME"
  ttl     = "60"
  records = ["vbr-beta-mgmtsvc.azurewebsites.net"]
}

resource "aws_route53_record" "awverify_beta_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "awverify.beta"
  type    = "CNAME"
  ttl     = "60"
  records = ["awverify.vbr-beta-mgmtsvc.azurewebsites.net"]
}

// The ones below are already part of the new architecture
resource "aws_route53_record" "docs_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "docs"
  type    = "CNAME"
  ttl     = "60"
  records = [var.docs_fqdn]
}

resource "aws_route53_record" "portal_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "portal"
  type    = "CNAME"
  ttl     = "60"
  records = [var.portal_fqdn]
}

resource "aws_route53_record" "wms_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "wms"
  type    = "CNAME"
  ttl     = "60"
  records = [var.wms_db_fqdn]
}

resource "aws_route53_record" "dienstverlening_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "dienstverlening"
  type    = "CNAME"
  ttl     = "60"
  records = [var.dienstverlening_fqdn]
}

resource "aws_route53_record" "dienstverlening_api_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "dienstverlening-api"
  type    = "CNAME"
  ttl     = "60"
  records = [var.dienstverlening_api_fqdn]
}

resource "aws_route53_record" "organisatie_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "organisatie"
  type    = "CNAME"
  ttl     = "60"
  records = [var.organisatie_fqdn]
}

resource "aws_route53_record" "organisatie_api_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "organisatie-api"
  type    = "CNAME"
  ttl     = "60"
  records = [var.organisatie_api_fqdn]
}
