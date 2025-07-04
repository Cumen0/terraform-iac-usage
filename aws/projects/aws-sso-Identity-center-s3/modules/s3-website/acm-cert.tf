resource "aws_acm_certificate" "domain_cert" {
  domain_name               = "s3.${var.hosted_zone}"
  subject_alternative_names = ["www.s3.${var.hosted_zone}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.project_name}-${var.env}-ssl-cert"
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.domain_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.hosted_zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.domain_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
  
  depends_on = [aws_route53_record.cert_validation]
}

resource "aws_route53_record" "main_domain" {
  zone_id = var.hosted_zone_id
  name    = "s3.${var.hosted_zone}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
  
  depends_on = [aws_acm_certificate_validation.cert_validation]
}

resource "aws_route53_record" "www_domain" {
  zone_id = var.hosted_zone_id
  name    = "www.s3.${var.hosted_zone}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
  
  depends_on = [aws_acm_certificate_validation.cert_validation]
}
