terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  version = ">= 2.50"
  region  = "ap-northeast-1"
}

