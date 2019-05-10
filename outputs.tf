output "cf_distribution_id" {
  description = "The ID of the cloud front distro we created. Use this for DNS alias records and invalidation."
  value       = "${aws_cloudfront_distribution.web_distro.id}"
}

output "cf_domain" {
  description = "The domain name of the CF distribution."
  value       = "${aws_cloudfront_distribution.web_distro.domain_name}"
}

output "cf_hosted_zone_id" {
  description = "The hosted zone of the CF distro. Use this when pointing alias records to the distro."
  value       = "${aws_cloudfront_distribution.web_distro.hosted_zone_id}"
}
