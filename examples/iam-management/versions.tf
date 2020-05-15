terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    bucket         = "terraform-aws-modules-tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    key            = "iam-management.examples"
    dynamodb_table = "terraform-aws-modules-tfstate-lock"
  }
}

provider "aws" {
  version = ">= 2.62"
  region  = "ap-northeast-1"
}
