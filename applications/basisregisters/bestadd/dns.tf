resource "aws_api_gateway_domain_name" "gw" {
  domain_name = "${var.api_url}.${replace(var.public_zone_name, "/[.]$/", "")}"

  certificate_arn = "${aws_acm_certificate.cert.arn}"
}

data "aws_route53_zone" "gw_zone" {
  name         = "${var.public_zone_name}"
  private_zone = false
}

resource "aws_route53_record" "gw_record" {
  zone_id = "${data.aws_route53_zone.gw_zone.id}"

  name = "${aws_api_gateway_domain_name.gw.domain_name}"
  type = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name.gw.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.gw.cloudfront_zone_id}"
    evaluate_target_health = true
  }
}

// TODO: It is possible we can remove this thanks to the wildcard DNS, unless it doesnt work with 2 subdomains
// resource "aws_route53_record" "api_gw_record" {
//   zone_id = "${data.aws_route53_zone.gw_zone.id}"
//   type    = "CNAME"
//   name    = "api.${var.api_name}"
//   ttl     = "300"
//   records = ["${data.terraform_remote_state.hashi_servers.lb_fqdn}"]
// }

