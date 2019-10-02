terraform {
  required_version = ">= 0.12.0"
}

module "backend" {
  source         = "../../backend-s3"
  region         = "ap-northeast-1"
  s3_bucket      = "terraform-aws-modules-tfstate"
  dynamodb_table = "terraform-aws-modules-tfstate-lock"
}
