# ---------------------------------------------
# CloudFront Web
# ---------------------------------------------

resource "aws_cloudfront_distribution" "web" {

  comment = "cloudfront-${var.owner}-web"
  enabled = true

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
    "HEAD"]
    target_origin_id         = "ELB-${aws_lb.alb_public_web.name}"
    viewer_protocol_policy   = "allow-all"
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
    min_ttl                  = 0
    default_ttl              = 0
    max_ttl                  = 0
    compress                 = false
    smooth_streaming         = false

  }

  origin {
    domain_name = aws_lb.alb_public_web.dns_name
    origin_id   = "ELB-${aws_lb.alb_public_web.name}"

    custom_header {
      name  = var.owner
      value = var.owner
    }

    custom_origin_config {
      http_port              = 80
      https_port             = 80
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  viewer_certificate {
    cloudfront_default_certificate = true
  }

}
