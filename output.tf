output "cloudfront" {
  value = aws_cloudfront_distribution.web.domain_name
}