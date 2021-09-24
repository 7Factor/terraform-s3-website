resource "aws_cloudfront_origin_access_identity" "access_id" {
  comment = "Created to facilitate CF access to ${var.primary_fqdn} and the corresponding bucket."
}

resource "aws_cloudfront_distribution" "web_distro" {
  enabled         = true
  is_ipv6_enabled = true

  default_root_object = "index.html"
  aliases             = var.origins

  origin {
    domain_name = aws_s3_bucket.web.bucket_regional_domain_name
    origin_id   = var.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.access_id.cloudfront_access_identity_path
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.cert_arn
    ssl_support_method  = "sni-only"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = var.forward_query_strings

      cookies {
        forward           = var.forward_cookies
        whitelisted_names = var.whitelisted_cookie_names
      }
    }

    min_ttl     = var.origin_min_ttl
    default_ttl = var.origin_default_ttl
    max_ttl     = var.origin_max_ttl
  }

  dynamic "custom_error_response" {
    for_each = [for c in var.custom_error_responses : {
      error_caching_min_ttl = c.error_caching_min_ttl
      error_code            = c.error_code
      response_code         = c.response_code
      response_page_path    = c.response_page_path
    }]

    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
      locations        = var.restriction_locations
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior_enabled[*]

    content {
      path_pattern     = var.ordered_cache_behavior_path_pattern
      allowed_methods  = var.ordered_cache_behavior_allowed_methods
      cached_methods   = var.ordered_cache_behavior_cached_methods
      target_origin_id = var.s3_origin_id

      forwarded_values {
        query_string = var.ordered_cache_forwarded_values_query_string

        cookies {
          forward = var.ordered_cache_forwarded_values_cookies_forward
        }
      }

      min_ttl                = var.ordered_cache_behavior_min_ttl
      default_ttl            = var.ordered_cache_behavior_default_ttl
      max_ttl                = var.ordered_cache_behavior_max_ttl
      compress               = var.ordered_cache_behavior_compress
      viewer_protocol_policy = var.ordered_cache_behavior_viewer_protocol_policy

      lambda_function_association {
        event_type   = var.ordered_cache_behavior_lambda_function_association_event_type
        include_body = var.ordered_cache_behavior_lambda_function_association_include_body
        lambda_arn   = var.ordered_cache_behavior_lambda_function_association_lambda_arn
      }
    }
  }
}