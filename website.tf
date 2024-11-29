terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "website" {
  bucket = "davidebotti.com"
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  ignore_public_acls      = true
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.website.arn}/*"
      },
    ]
  })
}

resource "aws_s3_bucket" "www_redirect" {
  bucket = "www.davidebotti.com"
}

resource "aws_s3_bucket_website_configuration" "www_redirect_config" {
  bucket = aws_s3_bucket.www_redirect.id

  redirect_all_requests_to {
    host_name = "davidebotti.com"
    protocol  = "http"
  }
}

resource "aws_s3_bucket_public_access_block" "www_redirect" {
  bucket = aws_s3_bucket.www_redirect.id

  ignore_public_acls      = true
}

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

