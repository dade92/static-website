resource "aws_s3_object" "object-upload-html" {
  for_each     = fileset("uploads/", "*.html")
  bucket       = aws_s3_bucket.website.bucket
  key          = each.value
  source       = "uploads/${each.value}"
  content_type = "text/html"
  etag         = filemd5("uploads/${each.value}")
}

resource "aws_s3_object" "object-upload-js" {
  for_each     = fileset("uploads/static/js", "*.js")
  bucket       = aws_s3_bucket.website.bucket
  key          = "static/js/${each.value}"
  source       = "uploads/static/js/${each.value}"
  content_type = "text/html"
  etag         = filemd5("uploads/static/js/${each.value}")
}

resource "aws_s3_object" "object-upload-css" {
  for_each     = fileset("uploads/static/css", "*.css")
  bucket       = aws_s3_bucket.website.bucket
  key          = "static/css/${each.value}"
  source       = "uploads/static/css/${each.value}"
  content_type = "text/html"
  etag         = filemd5("uploads/static/css/${each.value}")
}