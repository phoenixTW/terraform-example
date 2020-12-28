resource "aws_lambda_function" "local_zipfile" {
  count = var.function_s3_bucket == "" ? 1 : 0

  filename         = var.function_zipfile
  source_code_hash = var.function_s3_bucket == "" ? base64sha256(file(var.function_zipfile)) : ""

  description   = "${var.comment_prefix}${var.api_domain}"
  function_name = local.prefix_with_domain
  handler       = var.function_handler
  runtime       = var.function_runtime
  timeout       = var.function_timeout
  memory_size   = var.memory_size
  role          = aws_iam_role.this.arn
  tags          = var.tags

  environment {
    variables = var.function_env_vars
  }
}

resource "aws_lambda_function" "s3_zipfile" {
  count = var.function_s3_bucket == "" ? 0 : 1

  s3_bucket = var.function_s3_bucket
  s3_key    = var.function_zipfile

  description   = "${var.comment_prefix}${var.api_domain}"
  function_name = local.prefix_with_domain
  handler       = var.function_handler
  runtime       = var.function_runtime
  timeout       = var.function_timeout
  memory_size   = var.memory_size
  role          = aws_iam_role.this.arn
  tags          = var.tags

  environment {
    variables = var.function_env_vars
  }
}

locals {
  function_id         = "${element(concat(aws_lambda_function.local_zipfile.*.id, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.id, list("")), 0)}"
  function_arn        = "${element(concat(aws_lambda_function.local_zipfile.*.arn, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.arn, list("")), 0)}"
  function_invoke_arn = "${element(concat(aws_lambda_function.local_zipfile.*.invoke_arn, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.invoke_arn, list("")), 0)}"
}