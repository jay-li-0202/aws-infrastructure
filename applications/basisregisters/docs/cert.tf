locals {
  zonemap = map(
    "docs.${var.cert_public_zone_name}", var.cert_public_zone_id,
    "docs.${var.cert_alias_zone_name}", var.cert_alias_zone_id,
  )
}

resource "aws_acm_certificate" "docs" {
  validation_method = "DNS"
  domain_name       = "docs.${var.cert_public_zone_name}"

  subject_alternative_names = [
    "docs.${var.cert_alias_zone_name}",
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "Basisregisters Docs Certificate // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_route53_record" "public_cert_validation" {
  count = length(local.zonemap)

  zone_id = lookup(local.zonemap, "${lookup(aws_acm_certificate.docs.domain_validation_options[count.index], "domain_name")}.")

  name    = lookup(aws_acm_certificate.docs.domain_validation_options[count.index], "resource_record_name")
  type    = lookup(aws_acm_certificate.docs.domain_validation_options[count.index], "resource_record_type")
  records = [lookup(aws_acm_certificate.docs.domain_validation_options[count.index], "resource_record_value")]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "docs" {
  certificate_arn = aws_acm_certificate.docs.arn
  validation_record_fqdns = aws_route53_record.public_cert_validation.*.fqdn
}
