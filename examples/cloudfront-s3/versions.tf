terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  version = ">= 2.50"
  region  = "ap-northeast-1"
}

provider "aws" {
  version = ">= 2.50"
  region  = "us-east-1"
  alias   = "us_east_1"
}
