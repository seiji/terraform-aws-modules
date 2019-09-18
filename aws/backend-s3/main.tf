terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = "~> 2.22"
  region  = var.region
}

resource "aws_s3_bucket" "this" {
  bucket = var.s3_bucket
  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "this" {
  name           = var.dynamodb_table
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
