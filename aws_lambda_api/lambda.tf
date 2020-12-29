module "my_api" {
  source = "git::ssh://git@github.com/futurice/terraform-utils.git//aws_lambda_api?ref=v11.0"

  api_domain             = "api.iamkaustav.com"
  lambda_logging_enabled = true
  function_zipfile       = "${path.module}/one-liner-joke/dist/lambda.zip"
}
