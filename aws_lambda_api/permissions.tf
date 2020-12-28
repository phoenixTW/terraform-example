resource "aws_iam_role" "this" {
  name = local.prefix_with_domain
  tags = var.tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = local.function_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_stage.this.execution_arn}/*/*"
}

resource "aws_iam_policy" "this" {
  count = var.lambda_logging_enabled ? 1 : 0
  name  = local.prefix_with_domain

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = var.lambda_logging_enabled ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}