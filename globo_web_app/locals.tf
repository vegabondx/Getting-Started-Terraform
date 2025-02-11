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

  user_data_script = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
aws s3 cp s3://${aws_s3_bucket.s3bucket.id}/website/index.html /home/ec2-user/index.html
aws s3 cp s3://${aws_s3_bucket.s3bucket.id}/website/Globo_logo_Vert.png /home/ec2-user/Globo_logo_Vert.png
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/Globo_logo_Vert.png /usr/share/nginx/html/Globo_logo_Vert.png
EC2_DNS=`curl http://169.254.169.254/latest/meta-data/public-hostname`
sed -i "s/DNS_ADDRESS/$EC2_DNS/g" /usr/share/nginx/html/index.html
EOF

}

resource "random_integer" "s3suffix" {
  min = 10000
  max = 99999
  
}
