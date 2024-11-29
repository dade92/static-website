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
  bucket                  = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
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