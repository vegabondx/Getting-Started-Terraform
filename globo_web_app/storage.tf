
# Get the elb service account
data "aws_elb_service_account" "root" {}

# Instance of Module Web bucket
module "web_bucket" {
  source                      = "./modules/s3"
  s3_bucket_name              = local.s3_bucket_name
  resource_policy_account_arn = data.aws_elb_service_account.root.arn
  common_tags                 = local.common_tags

}


#COPY objects required by the website
resource "aws_s3_object" "website" {
  for_each = fileset("${path.root}/../website/", "*")
  bucket   = module.web_bucket.bucket
  key      = "website/${each.value}"
  source   = "${path.root}/../website/${each.value}"
  etag     = filemd5("${path.root}/../website/${each.value}")
  tags     = local.common_tags

}
