output "cloud_formation_distribution_id" {
  description = "The ID of the cloud front distro we created. Use this for DNS alias records and invalidation."
  value       = "${aws_cloudfront_distribution.web_distro.id}"
}
