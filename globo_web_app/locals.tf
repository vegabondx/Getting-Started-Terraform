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

}
