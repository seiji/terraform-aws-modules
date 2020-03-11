data terraform_remote_state vpc {
  backend = "s3"

  config = {
    bucket = "terraform-aws-modules-tfstate"
    region = "ap-northeast-1"
    key    = "vpc-nati.examples"
  }
}

locals {
  namespace = "cloudfront-s3"
  stage     = "staging"
  vpc = {
    id                        = data.terraform_remote_state.vpc.outputs.id
    default_security_group_id = data.terraform_remote_state.vpc.outputs.default_security_group_id
    private_subnet_ids        = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_subnet_ids         = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  }
  alias = "${join("-", [local.namespace, local.stage])}.seiji.me"
}

module s3_backend {
  source     = "../../s3"
  namespace  = local.namespace
  stage      = local.stage
  attributes = ["backend"]
  lifecycle_rule = {
    enabled                                = true
    abort_incomplete_multipart_upload_days = 7
    expiration = {
      days                         = 365
      expired_object_delete_marker = false
    }
    noncurrent_version_expiration = {
      days = 365
    }
    transitions = [
      {
        days          = 0
        storage_class = "INTELLIGENT_TIERING"
      },
      {
        days          = 100
        storage_class = "GLACIER"
      },
    ]
  }
}

data aws_acm_certificate seiji_me {
  provider = aws.us_east_1
  domain   = "*.seiji.me"
  statuses = ["ISSUED"]
}

module cloudfront {
  source              = "../../cloudfront"
  namespace           = local.namespace
  stage               = local.stage
  aliases             = [local.alias]
  default_root_object = "index.html"
  custom_error_response = [
    {
      error_caching_min_ttl = 300
      error_code            = 403
      response_code         = 404
      response_page_path    = "/404.html"
    },
    {
      error_caching_min_ttl = 300
      error_code            = 503
      response_code         = 503
      response_page_path    = "/503.html"
    },
  ]
  origin = {
    domain_name          = module.s3_backend.bucket_domain_name
    origin_id            = "s3-cloudfront-s3-staging-backend"
    origin_path          = "/public"
    custom_origin_config = null
    s3_origin            = true
  }
  viewer_certificate = {
    acm_certificate_arn            = data.aws_acm_certificate.seiji_me.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.1_2016"
    ssl_support_method             = "sni-only"
  }
}

resource aws_s3_bucket_policy this {
  bucket = module.s3_backend.id

  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Id": "PolicyForCloudFrontPrivateContent",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${module.cloudfront.origin_access_identity_iam_arn}"
      },
      "Action": "s3:GetObject",
      "Resource": "${module.s3_backend.arn}/*"
    }
  ]
}
POLICY
}

data aws_route53_zone this {
  name         = "seiji.me."
  private_zone = false
}

module route53_record_alias {
  source        = "../../route53-record-alias"
  name          = local.alias
  zone_id       = data.aws_route53_zone.this.zone_id
  alias_name    = module.cloudfront.domain_name
  alias_zone_id = module.cloudfront.hosted_zone_id
}

