variable "datadog_key" {
  type        = string
  description = "API Key used to ship logs (https://app.datadoghq.com/account/settings#api)"
}

variable "environment" {
  type        = string
  description = "Environment prefix"
  default     = "default"
}

variable "reserved_concurrent_executions" {
  type        = string
  description = "Number of reserved concurrent executions (default 10)"
  default     = "10"
}

variable "url" {
  description = "URL to script content."
  default     = "https://raw.githubusercontent.com/DataDog/datadog-serverless-functions/2.1.0/aws/logs_monitoring/lambda_function.py"
}

variable "redact_ip" {
  type        = bool
  description = "Boolean to redact IP from logs before sending to Datadog"
  default     = false
}

variable "redact_email" {
  type        = bool
  description = "Boolean to redact email from logs before sending to Datadog"
  default     = false
}
