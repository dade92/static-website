resource "aws_route53_zone" "davidebotti_com" {
  name = "davidebotti.com"
}

resource "aws_route53_record" "root_alias" {
  zone_id = aws_route53_zone.davidebotti_com.zone_id
  name    = "davidebotti.com"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.website_config.website_endpoint
    zone_id                = aws_s3_bucket.website.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_alias" {
  zone_id = aws_route53_zone.davidebotti_com.zone_id
  name    = "www.davidebotti.com"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.www_redirect_config.website_endpoint
    zone_id                = aws_s3_bucket.www_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}

