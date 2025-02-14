# Get the account id as prefix
data "aws_caller_identity" "current" {}

# Local variables and constants
locals {
  common_tags = {
    company      = var.company
    project      = "${var.company}-${var.project}"
    billing_code = var.billing_code
  }

  vpc_cidr_block = "10.0.0.0/16"

  s3_bucket_prefix = "${data.aws_caller_identity.current.account_id}-${var.prefix}-"

}

resource "random_integer" "s3suffix" {
  min = 10000
  max = 99999

}
