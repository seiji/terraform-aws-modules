data "aws_region" "this" {}

resource "aws_securityhub_account" "this" {}

resource "aws_securityhub_standards_subscription" "this" {
  depends_on    = [aws_securityhub_account.this]
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}

resource "aws_securityhub_product_subscription" "guardduty" {
  depends_on  = [aws_securityhub_account.this]
  product_arn = "arn:aws:securityhub:${data.aws_region.this.name}::product/aws/guardduty"
}

resource "aws_securityhub_product_subscription" "inspector" {
  depends_on  = [aws_securityhub_account.this]
  product_arn = "arn:aws:securityhub:${data.aws_region.this.name}::product/aws/inspector"
}

resource "aws_securityhub_product_subscription" "macie" {
  depends_on  = [aws_securityhub_account.this]
  product_arn = "arn:aws:securityhub:${data.aws_region.this.name}::product/aws/macie"
}
