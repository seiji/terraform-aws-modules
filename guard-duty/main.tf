resource "aws_guardduty_detector" "this" {
  enable                       = var.enable
  finding_publishing_frequency = "SIX_HOURS"
}
