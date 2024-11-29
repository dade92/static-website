provider "aws" {
  region = "eu-central-1" 
}

resource "aws_s3_bucket" "website" {
  bucket = "davidebotti.com"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  acl = "public-read"
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket" "www_redirect" {
  bucket = "www.davidebotti.com"

  website {
    redirect_all_requests_to = "http://davidebotti.com"
  }
}

resource "aws_route53_zone" "davidebotti_com" {
  name = "davidebotti.com"
}

resource "aws_route53_record" "root_alias" {
  zone_id = aws_route53_zone.davidebotti_com.zone_id
  name    = "davidebotti.com"
  type    = "A"

  alias {
    name                   = aws_s3_bucket.website.website_endpoint
    zone_id                = aws_s3_bucket.website.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_alias" {
  zone_id = aws_route53_zone.davidebotti_com.zone_id
  name    = "www.davidebotti.com"
  type    = "A"

  alias {
    name                   = aws_s3_bucket.www_redirect.website_endpoint
    zone_id                = aws_s3_bucket.www_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}

