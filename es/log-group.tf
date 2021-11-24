resource "aws_cloudwatch_log_group" "search_logs" {
  count = var.search_logs_enabled ? 1 : 0
  name  = "/aws/aes/domains/${local.domain_name}/search-logs"
}

resource "aws_cloudwatch_log_resource_policy" "search_logs" {
  count = var.search_logs_enabled ? 1 : 0

  policy_name     = join("-", [local.domain_name, "search-logs"])
  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:CreateLogStream"
      ],
      "Resource": "${aws_cloudwatch_log_group.search_logs[0].arn}:*"
    }
  ]
}
CONFIG
  depends_on      = [aws_cloudwatch_log_group.search_logs[0]]
}

resource "aws_cloudwatch_log_group" "index_logs" {
  count = var.index_logs_enabled ? 1 : 0
  name  = "/aws/aes/domains/${local.domain_name}/index-logs"
}

resource "aws_cloudwatch_log_resource_policy" "index_logs" {
  count = var.index_logs_enabled ? 1 : 0

  policy_name     = join("-", [local.domain_name, "index-logs"])
  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:CreateLogStream"
      ],
      "Resource": "${aws_cloudwatch_log_group.index_logs[0].arn}:*"
    }
  ]
}
CONFIG
  depends_on      = [aws_cloudwatch_log_group.index_logs[0]]
}

resource "aws_cloudwatch_log_group" "application_logs" {
  count = var.application_logs_enabled ? 1 : 0
  name  = "/aws/aes/domains/${local.domain_name}/application-logs"
}

resource "aws_cloudwatch_log_resource_policy" "application_logs" {
  count = var.application_logs_enabled ? 1 : 0

  policy_name     = join("-", [local.domain_name, "application-logs"])
  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:CreateLogStream"
      ],
      "Resource": "${aws_cloudwatch_log_group.application_logs[0].arn}:*"
    }
  ]
}
CONFIG
  depends_on      = [aws_cloudwatch_log_group.application_logs[0]]
}
