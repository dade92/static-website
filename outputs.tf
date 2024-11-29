output "bucket_regional_name" {
  value = aws_s3_bucket.website.bucket_regional_domain_name
}

output "bucket_domain_name" {
  value = aws_s3_bucket.website.bucket_domain_name
}

output "bucket_website_name" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}