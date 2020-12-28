data "aws_route53_zone" "this" {
  name = replace("${var.api_domain}", "/.*\\b(\\w+\\.\\w+)\\.?$/", "$1")
}
