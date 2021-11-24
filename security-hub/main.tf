data "aws_region" "this" {}

resource "aws_securityhub_account" "this" {}

resource "aws_securityhub_standards_subscription" "this" {
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
  depends_on    = [aws_securityhub_account.this]
}

resource "aws_securityhub_product_subscription" "guardduty" {
  product_arn = "arn:aws:securityhub:${data.aws_region.this.name}::product/aws/guardduty"
  depends_on  = [aws_securityhub_account.this]
}

resource "aws_securityhub_product_subscription" "inspector" {
  product_arn = "arn:aws:securityhub:${data.aws_region.this.name}::product/aws/inspector"
  depends_on  = [aws_securityhub_account.this]
}

resource "aws_securityhub_product_subscription" "macie" {
  product_arn = "arn:aws:securityhub:${data.aws_region.this.name}::product/aws/macie"
  depends_on  = [aws_securityhub_account.this]
}
