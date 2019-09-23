terraform {
  required_version = ">= 0.12.0"
}

module "backend" {
  source         = "../../backend-s3"
  region         = "ap-northeast-1"
  s3_bucket      = "aws-modules-tfstate"
  dynamodb_table = "aws-modules-tfstate-lock"
}