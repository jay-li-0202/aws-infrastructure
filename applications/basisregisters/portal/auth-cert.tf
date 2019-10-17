resource "aws_acm_certificate" "auth" {
  provider = aws.cert

  validation_method = "DNS"
  domain_name       = "auth.${var.cert_public_zone_name}"

  subject_alternative_names = [
    "auth.${var.cert_alias_zone_name}",
  ]

  tags = {
    Name        = "Basisregisters Auth Certificate // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_route53_record" "auth_public_cert_validation0" {
  zone_id = var.cert_public_zone_id

  name    = aws_acm_certificate.auth.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.auth.domain_validation_options.0.resource_record_type
  records = [aws_acm_certificate.auth.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "auth_public_cert_validation1" {
  zone_id = var.cert_alias_zone_id

  name    = aws_acm_certificate.auth.domain_validation_options.1.resource_record_name
  type    = aws_acm_certificate.auth.domain_validation_options.1.resource_record_type
  records = [aws_acm_certificate.auth.domain_validation_options.1.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "auth" {
  certificate_arn = aws_acm_certificate.auth.arn

  validation_record_fqdns = [
    aws_route53_record.auth_public_cert_validation0.fqdn,
    aws_route53_record.auth_public_cert_validation1.fqdn,
  ]
}
