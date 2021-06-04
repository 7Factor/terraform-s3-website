# Required variables
variable "primary_fqdn" {
  description = "This is what we will name the S3 bucket. This must be in the list of DNS names that the app will be served from otherwise this won't work correctly."
}

variable "origins" {
  type        = list(string)
  description = "This is a list of domain names that will be passed into the CORS rule for the S3 bucket and the aliases list for cloud front. "
}

variable "s3_origin_id" {
  description = "A unique name value to assign to the s3 origin in CF. Try not to change it much."
}

variable "forward_query_strings" {
  description = "Should we forward query strings?"
}

variable "cert_arn" {
  description = "The ARN for a cert that will be fronting this distro. Make sure it exists."
}

# Optional variables
variable "routing_rules" {
  description = "A string containing a compatible policy document with routing rules to assign to the S3 bucket. Defaults to empty."
  default     = ""
}

variable "web_index_doc" {
  description = "The path to the file where your app will deploy it's entrypoint."
  default     = "index.html"
}

variable "web_error_doc" {
  description = "The path to any custom error files that S3 will serve if there's a problem."
  default     = "error.html"
}

variable "cors_max_age_seconds" {
  description = "Max age for a CORS call in seconds. Assigned to the cors rules for the S3 bucket."
  default     = 3000
}

variable "cors_expose_headers" {
  type        = list(string)
  description = "The list of headers to expose on the S3 bucket. Defaults to an empty list."
  default     = []
}

variable "custom_error_responses" {
  type        = list(any)
  description = "A list of custom error response blocks. You probably won't need this unless you have a complex deployment."
  default     = []
}

variable "forward_cookies" {
  description = "What cookie forwarding policy should we use? Check the docs in terraform for info on this."
  default     = "none"
}

variable "whitelisted_cookie_names" {
  type        = list(string)
  description = "A list of cookies to whitelist."
  default     = []
}

variable "origin_min_ttl" {
  description = "Origin min TTL."
  default     = 0
}

variable "origin_default_ttl" {
  description = "Origin default TTL."
  default     = 3600
}

variable "origin_max_ttl" {
  description = "Origin max TTL."
  default     = 86400
}

variable "restriction_type" {
  description = "The restriction type for the CF distro when restricting content. Defaults to none."
  default     = "none"
}

variable "restriction_locations" {
  type        = list(string)
  description = "The list of locations to apply to the restriction type. Note this is ignored if the restriction type is none."
  default     = []
}

variable "compress" {
  description = "Whether to compress files from the CF distro"
  default     = true
}
