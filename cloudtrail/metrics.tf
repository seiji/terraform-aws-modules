locals {
  metric_namespace = "CloudTrailMetrics"
  metric_filter_transformation = {
    namespace     = local.metric_namespace
    value         = 1
    default_value = 0
  }
  metric_alarm = {
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    period              = 300
    statistic           = "Sum"
    threshold           = 1
    treat_missing_data  = "notBreaching"
  }
  metric_filter_patterns = {
    # 3.1 Ensure a log metric filter and alarm exist for unauthorized API calls
    UnauthorizedAPICalls = <<PATTERN
    {
      ($.errorCode = "*UnauthorizedOperation") || ($.errorCode ="AccessDenied*")
    }
    PATTERN
    # 3.2 Ensure a log metric filter and alarm exist for Management Console sign-in without MFA
    ConsoleSigninWithoutMFA = <<PATTERN
    {
      ($.eventName = "ConsoleLogin") && ($.additionalEventData.MFAUsed != "Yes")
    }
    PATTERN
    # 3.3 Ensure a log metric filter and alarm exist for usage of "root" account
    RootAccountUsage = <<PATTERN
    {
      ($.userIdentity.type = "Root") && ($.userIdentity.invokedBy NOT EXISTS) && ($.eventType != "AwsServiceEvent")
    }
    PATTERN
    # 3.4 Ensure a log metric filter and alarm exist for IAM policy changes
    IAMPolicyChange = <<PATTERN
    {
      ($.eventName=DeleteGroupPolicy) ||
      ($.eventName=DeleteRolePolicy) ||
      ($.eventName=DeleteUserPolicy) ||
      ($.eventName=PutGroupPolicy) ||
      ($.eventName=PutRolePolicy) ||
      ($.eventName=PutUserPolicy) ||
      ($.eventName=CreatePolicy) ||
      ($.eventName=DeletePolicy) ||
      ($.eventName=CreatePolicyVersion) ||
      ($.eventName=DeletePolicyVersion) ||
      ($.eventName=AttachRolePolicy) ||
      ($.eventName=DetachRolePolicy) ||
      ($.eventName=AttachUserPolicy) ||
      ($.eventName=DetachUserPolicy) ||
      ($.eventName=AttachGroupPolicy) ||
      ($.eventName=DetachGroupPolicy)
    }
    PATTERN
    # 3.5 Ensure a log metric filter and alarm exist for CloudTrail configuration changes
    CloudTrailConfigChanges = <<PATTERN
    {
      ($.eventName = CreateTrail) ||
      ($.eventName = UpdateTrail) ||
      ($.eventName = DeleteTrail) ||
      ($.eventName = StartLogging) ||
      ($.eventName = StopLogging)
    }
    PATTERN
    # 3.6 Ensure a log metric filter and alarm exist for AWS Management Console authentication failures
    ConsoleLoginFaillures = <<PATTERN
    {
      ($.eventName = "ConsoleLogin") && ($.errorMessage = "Failed authentication")
    }
    PATTERN
    # 3.7 Ensure a log metric filter and alarm exist for disabling or scheduled deletion of customer created CMKs
    KMSCustomerKeyDeletion = <<PATTERN
    {
      ($.eventSource = kms.amazonaws.com) &&
      (($.eventName=DisableKey) || ($.eventName=ScheduleKeyDeletion))
    }
    PATTERN
    # 3.8 Ensure a log metric filter and alarm exist for S3 bucket policy changes
    S3BucketPolicyChanges = <<PATTERN
    {
      ($.eventSource = s3.amazonaws.com) &&
      (($.eventName = PutBucketAcl) ||
      ($.eventName = PutBucketPolicy) ||
      ($.eventName = PutBucketCors) ||
      ($.eventName = PutBucketLifecycle) ||
      ($.eventName = PutBucketReplication) ||
      ($.eventName = DeleteBucketPolicy) ||
      ($.eventName = DeleteBucketCors) ||
      ($.eventName = DeleteBucketLifecycle) ||
      ($.eventName = DeleteBucketReplication))
    }
    PATTERN
    # 3.9 Ensure a log metric filter and alarm exist for AWS Config configuration changes
    AWSConfigConfiguraionChanges = <<PATTERN
    {

      ($.eventSource = config.amazonaws.com) &&
      (($.eventName=StopConfigurationRecorder)||
      ($.eventName=DeleteDeliveryChannel)||
      ($.eventName=PutDeliveryChannel)||
      ($.eventName=PutConfigurationRecorder))
    }
    PATTERN
    # 3.10 Ensure a log metric filter and alarm exist for security group changes
    SecurityGroupChanges = <<PATTERN
    {
      ($.eventName = AuthorizeSecurityGroupIngress) ||
      ($.eventName = AuthorizeSecurityGroupEgress) ||
      ($.eventName = RevokeSecurityGroupIngress) ||
      ($.eventName = RevokeSecurityGroupEgress) ||
      ($.eventName = CreateSecurityGroup) ||
      ($.eventName = DeleteSecurityGroup)
    }
    PATTERN
    # 3.11 Ensure a log metric filter and alarm exist for changes to Network Access Control Lists (NACL)
    NACLChanges = <<PATTERN
    {
      ($.eventName = CreateNetworkAcl) ||
      ($.eventName = CreateNetworkAclEntry) ||
      ($.eventName = DeleteNetworkAcl) ||
      ($.eventName = DeleteNetworkAclEntry) ||
      ($.eventName = ReplaceNetworkAclEntry) ||
      ($.eventName = ReplaceNetworkAclAssociation)

    }
    PATTERN
    # 3.12 Ensure a log metric filter and alarm exist for changes to network gateways
    NetworkGatewayChanges = <<PATTERN
    {
      ($.eventName = CreateCustomerGateway) ||
      ($.eventName = DeleteCustomerGateway) ||
      ($.eventName = AttachInternetGateway) ||
      ($.eventName = CreateInternetGateway) ||
      ($.eventName = DeleteInternetGateway) ||
      ($.eventName = DetachInternetGateway)
    }
    PATTERN
    # 3.13 Ensure a log metric filter and alarm exist for route table changes
    RouteTableChanges = <<PATTERN
    {
      ($.eventName = CreateRoute) ||
      ($.eventName = CreateRouteTable) ||
      ($.eventName = ReplaceRoute) ||
      ($.eventName = ReplaceRouteTableAssociation) ||
      ($.eventName = DeleteRouteTable) ||
      ($.eventName = DeleteRoute) ||
      ($.eventName = DisassociateRouteTable)
    }
    PATTERN
    # 3.14 Ensure a log metric filter and alarm exist for VPC changes
    VPCChanges = <<PATTERN
    {
      ($.eventName = CreateVpc) ||
      ($.eventName = DeleteVpc) ||
      ($.eventName = ModifyVpcAttribute) ||
      ($.eventName = AcceptVpcPeeringConnection) ||
      ($.eventName = CreateVpcPeeringConnection) ||
      ($.eventName = DeleteVpcPeeringConnection) ||
      ($.eventName = RejectVpcPeeringConnection) ||
      ($.eventName = AttachClassicLinkVpc) ||
      ($.eventName = DetachClassicLinkVpc) ||
      ($.eventName = DisableVpcClassicLink) ||
      ($.eventName = EnableVpcClassicLink)
    }
    PATTERN
  }
}

resource "aws_cloudwatch_log_metric_filter" "this" {
  for_each       = var.cloudwatch_metric_alarm.enabled ? local.metric_filter_patterns : {}
  name           = each.key
  pattern        = each.value
  log_group_name = var.cloudwatch_log_group_name
  metric_transformation {
    name          = each.key
    namespace     = local.metric_filter_transformation.namespace
    value         = local.metric_filter_transformation.value
    default_value = local.metric_filter_transformation.default_value
  }
}

resource "aws_cloudwatch_metric_alarm" "this" {
  for_each            = var.cloudwatch_metric_alarm.enabled ? local.metric_filter_patterns : {}
  alarm_name          = join("-", [local.metric_namespace, each.key])
  comparison_operator = local.metric_alarm.comparison_operator
  evaluation_periods  = local.metric_alarm.evaluation_periods
  metric_name         = each.key
  namespace           = local.metric_filter_transformation.namespace
  statistic           = local.metric_alarm.statistic
  period              = local.metric_alarm.period
  threshold           = local.metric_alarm.threshold
  alarm_actions       = var.cloudwatch_metric_alarm.alarm_actions
  treat_missing_data  = local.metric_alarm.treat_missing_data
}
