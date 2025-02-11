# Get the account id as prefix
data "aws_caller_identity" "current" {}

locals {
  common_tags = {
    company      = var.company
    project      = "${var.company}-${var.project}"
    billing_code = var.billing_code
  }

  aws_cidr_blocks = {
    one = "10.0.0.0/24"
    two = "10.0.1.0/24"
  }

  s3_bucket_name = "${data.aws_caller_identity.current.account_id}-globo-web-app-${random_integer.s3suffix.result}"

}

resource "random_integer" "s3suffix" {
  min = 10000
  max = 99999
  
}
