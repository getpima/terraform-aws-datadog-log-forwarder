locals {
  output_file = "${path.module}/files/lambda/package.zip"
}

data "http" "datadog_forwarder" {
  url = var.url
}

data "aws_region" "current" {
}

data "archive_file" "datadog_forwarder" {
  type        = "zip"
  output_path = local.output_file

  source {
    filename = "lambda_function.py"
    content  = data.http.datadog_forwarder.body
  }
}

data "aws_iam_policy_document" "lambda_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com",
        "events.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name_prefix        = "lambda.datadog_forwarder"
  assume_role_policy = data.aws_iam_policy_document.lambda_execution_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_execution_basic" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "datadog_forwarder" {
  description                    = "AWS Lambda to forward logs to Datadog"
  filename                       = local.output_file
  source_code_hash               = data.archive_file.datadog_forwarder.output_base64sha256
  function_name                  = "datadog-log-monitoring-function"
  role                           = aws_iam_role.lambda_execution_role.arn
  handler                        = "lambda_function.lambda_handler"
  runtime                        = "python2.7"
  publish                        = true
  reserved_concurrent_executions = var.reserved_concurrent_executions

  environment {
    variables = {
      DD_API_KEY   = var.datadog_key,
      REDACT_IP    = var.redact_ip,
      REDACT_EMAIL = var.redact_email
    }
  }
}
