variable "s3_bucket_prefix" {
  type        = string
  description = "Prefix of bucket"
}

variable "common_tags" {
  type        = map(string)
  description = "common tags"
  default     = {}
}

variable "resource_policy_account_arn" {
  type        = string
  description = "resource access policy arns"
}


resource "aws_s3_bucket" "bucket_obj" {

  bucket_prefix = var.s3_bucket_prefix
  force_destroy = true
  tags          = var.common_tags

}

resource "aws_s3_bucket_policy" "web_bucket" {
  bucket = aws_s3_bucket.bucket_obj.bucket
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.resource_policy_account_arn}"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.bucket_obj.bucket}/alb-logs/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.bucket_obj.bucket}/alb-logs/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.bucket_obj.bucket}"
    }
  ]
}
POLICY
}

// Redundant output but yielding the entire bucket object
output "bucket_obj" {
  value = aws_s3_bucket.bucket_obj
}