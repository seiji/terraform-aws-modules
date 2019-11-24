terraform {
  required_version = "~> 0.12.0"
}

provider aws {
  version = "~> 2.22"
  region  = "ap-northeast-1"
}

module backend {
  source         = "../../backend"
  s3_bucket      = "terraform-aws-modules-tfstate"
  dynamodb_table = "terraform-aws-modules-tfstate-lock"
}
