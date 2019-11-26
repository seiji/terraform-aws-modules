resource aws_ssm_document this {
  name          = var.name
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "Installing and configuring CloudWatchAgent.",
    "mainSteps": [
      {
        "name": "InstallCloudWatchAgent",
        "action": "aws:runDocument",
        "onFailure": "Abort",
        "timeoutSeconds": 120,
        "inputs": {
          "documentType": "SSMDocument",
          "documentPath": "AWS-ConfigureAWSPackage",
          "documentParameters": {
            "action": "Install",
            "name" : "AmazonCloudWatchAgent"
          }
        }
      },
      {
        "name": "ConfigureCloudWatchAgent",
        "action": "aws:runDocument",
        "onFailure": "Abort",
        "timeoutSeconds": 600,
        "inputs": {
          "documentType": "SSMDocument",
          "documentPath": "AmazonCloudWatch-ManageAgent",
          "documentParameters": {
            "action":"configure",
            "mode" : "ec2",
            "optionalConfigurationSource" : "${var.config_name}",
            "optionalRestart" : "yes"
          }
        }
      }
    ]
  }
DOC
  tags = {
    "namespace" = var.namespace
    "stage"     = var.stage
  }
}
