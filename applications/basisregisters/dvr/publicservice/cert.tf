locals {
  zonemap = map(
    "dienstverlening-api.${var.cert_public_zone_name}", var.cert_public_zone_id,
    "dienstverlening.${var.cert_public_zone_name}", var.cert_public_zone_id,
    "dienstverlening-api.${var.cert_alias_zone_name}", var.cert_alias_zone_id,
    "dienstverlening.${var.cert_alias_zone_name}", var.cert_alias_zone_id,
  )
}

resource "aws_acm_certificate" "api" {
  validation_method = "DNS"
  domain_name       = "dienstverlening-api.${var.cert_public_zone_name}"

  subject_alternative_names = [    
    "dienstverlening.${var.cert_alias_zone_name}",
    "dienstverlening-api.${var.cert_alias_zone_name}",    
    "dienstverlening.${var.cert_public_zone_name}",
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "PublicService Api Certificate // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_route53_record" "public_cert_validation" {
  count = length(local.zonemap)

  zone_id = lookup(local.zonemap, "${lookup(aws_acm_certificate.api.domain_validation_options[count.index], "domain_name")}.")

  name    = lookup(aws_acm_certificate.api.domain_validation_options[count.index], "resource_record_name")
  type    = lookup(aws_acm_certificate.api.domain_validation_options[count.index], "resource_record_type")
  records = [lookup(aws_acm_certificate.api.domain_validation_options[count.index], "resource_record_value")]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "api" {
  certificate_arn         = aws_acm_certificate.api.arn
  validation_record_fqdns = aws_route53_record.public_cert_validation.*.fqdn
}
