locals {
  portal_zonemap = map(
    "portal.${var.cert_public_zone_name}", var.cert_public_zone_id,
    "portal.${var.cert_alias_zone_name}", var.cert_alias_zone_id,
  )
}

resource "aws_acm_certificate" "portal" {
  provider = aws.cert

  validation_method = "DNS"
  domain_name       = "portal.${var.cert_public_zone_name}"

  subject_alternative_names = [
    "portal.${var.cert_alias_zone_name}",
  ]

  tags = {
    Name        = "Basisregisters Portal Certificate // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_route53_record" "portal_public_cert_validation" {
  count = length(local.portal_zonemap)

  zone_id = lookup(local.portal_zonemap, "${lookup(aws_acm_certificate.portal.domain_validation_options[count.index], "domain_name")}.")

  name    = lookup(aws_acm_certificate.portal.domain_validation_options[count.index], "resource_record_name")
  type    = lookup(aws_acm_certificate.portal.domain_validation_options[count.index], "resource_record_type")
  records = [lookup(aws_acm_certificate.portal.domain_validation_options[count.index], "resource_record_value")]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "portal" {
  certificate_arn = aws_acm_certificate.portal.arn
  validation_record_fqdns = aws_route53_record.portal_public_cert_validation.*.fqdn
}
