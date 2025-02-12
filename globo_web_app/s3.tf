
resource "aws_s3_bucket" "s3bucket" {

  bucket        = local.s3_bucket_name
  force_destroy = true

  tags = local.common_tags

}

#COPY objects required by the website
resource "aws_s3_object" "website" {
  for_each = fileset("${path.root}/../website/", "*")
  bucket   = aws_s3_bucket.s3bucket.bucket
  key      = "website/${each.value}"
  source   = "${path.root}/../website/${each.value}"
  etag     = filemd5("${path.root}/../website/${each.value}")
  tags     = local.common_tags

}


# Get the elb service account
data "aws_elb_service_account" "root" {}

# Create Resource based policy 
resource "aws_s3_bucket_policy" "web_bucket" {
  bucket = aws_s3_bucket.s3bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_elb_service_account.root.arn}"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*",
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
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}"
    }
  ]
}
POLICY
}