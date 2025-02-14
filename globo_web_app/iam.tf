
#create role which can be assumed
resource "aws_iam_role" "s3accessrole" {
  name = "${var.prefix}-s3accessrole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

}

# Create policy that grants access
resource "aws_iam_policy" "s3bucketpolicy" {
  name        = "${var.prefix}-s3bucketpolicy"
  description = "A policy to allow access to an S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${module.web_bucket.bucket}",
          "arn:aws:s3:::${module.web_bucket.bucket}/*"
        ]
      }
    ]
  })
}

#associate policy with role 
resource "aws_iam_role_policy_attachment" "s3attachment" {
  role       = aws_iam_role.s3accessrole.name
  policy_arn = aws_iam_policy.s3bucketpolicy.arn
}

# Associate instance profile with s3access
resource "aws_iam_instance_profile" "s3access" {
  name = "${var.prefix}-s3access"
  role = aws_iam_role.s3accessrole.name
}