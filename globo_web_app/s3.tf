
resource "aws_s3_bucket" "s3bucket" {

    bucket = local.s3_bucket_name
    force_destroy = true

    tags = local.common_tags

}

#COPY objects required by the website
resource "aws_s3_object" "website" {
  bucket = aws_s3_bucket.s3bucket.bucket
  key    = "/website/index.html"
  source = "../website/index.html"

  tags = local.common_tags

}

resource "aws_s3_object" "graphic" {
  bucket = aws_s3_bucket.s3bucket.bucket
  key    = "/website/Globo_logo_Vert.png"
  source = "../website/Globo_logo_Vert.png"

  tags = local.common_tags

}