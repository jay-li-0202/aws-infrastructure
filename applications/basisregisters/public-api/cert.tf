resource "aws_acm_certificate" "api" {
  validation_method = "DNS"
  domain_name       = "public-api.${var.cert_public_zone_name}"

  subject_alternative_names = [
    "docs.${var.cert_public_zone_name}",
    "legacy-api.${var.cert_public_zone_name}",
    "dienstverlening.${var.cert_public_zone_name}",
    "dienstverlening-api.${var.cert_public_zone_name}",
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "Basisregisters Public Api Certificate // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_route53_record" "public_cert_validation0" {
  zone_id = var.cert_public_zone_id

  name    = aws_acm_certificate.api.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.api.domain_validation_options.0.resource_record_type
  records = [aws_acm_certificate.api.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "public_cert_validation1" {
  zone_id = var.cert_public_zone_id

  name    = aws_acm_certificate.api.domain_validation_options.1.resource_record_name
  type    = aws_acm_certificate.api.domain_validation_options.1.resource_record_type
  records = [aws_acm_certificate.api.domain_validation_options.1.resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "public_cert_validation2" {
  zone_id = var.cert_public_zone_id

  name    = aws_acm_certificate.api.domain_validation_options.2.resource_record_name
  type    = aws_acm_certificate.api.domain_validation_options.2.resource_record_type
  records = [aws_acm_certificate.api.domain_validation_options.2.resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "public_cert_validation3" {
  zone_id = var.cert_public_zone_id

  name    = aws_acm_certificate.api.domain_validation_options.3.resource_record_name
  type    = aws_acm_certificate.api.domain_validation_options.3.resource_record_type
  records = [aws_acm_certificate.api.domain_validation_options.3.resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "public_cert_validation4" {
  zone_id = var.cert_public_zone_id

  name    = aws_acm_certificate.api.domain_validation_options.4.resource_record_name
  type    = aws_acm_certificate.api.domain_validation_options.4.resource_record_type
  records = [aws_acm_certificate.api.domain_validation_options.4.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "api" {
  certificate_arn = aws_acm_certificate.api.arn

  validation_record_fqdns = [
    aws_route53_record.public_cert_validation0.fqdn,
    aws_route53_record.public_cert_validation1.fqdn,
    aws_route53_record.public_cert_validation2.fqdn,
    aws_route53_record.public_cert_validation3.fqdn,
    aws_route53_record.public_cert_validation4.fqdn,
  ]
}

