resource "aws_acm_certificate" "this" {
  domain_name       = var.api_domain
  validation_method = "DNS"
  tags              = merge(var.tags, map("Name", "${var.comment_prefix}${var.api_domain}"))
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.this.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.this.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.this.zone_id
  records = [aws_acm_certificate.this.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}