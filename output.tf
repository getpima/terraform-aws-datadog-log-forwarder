output "function_name" {
  value = "${aws_lambda_function.datadog_forwarder.function_name}"
}

output "lambda_arn" {
  value = "${aws_lambda_function.datadog_forwarder.arn}"
}
