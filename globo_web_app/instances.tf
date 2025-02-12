
# Get data for ami
data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Saving the user data script for reuse
locals {
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

# INSTANCES #
resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.s3access.name
  depends_on             = [aws_iam_role_policy_attachment.s3attachment]
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  user_data              = local.user_data_script
}

resource "aws_instance" "nginx2" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnets[1]
  depends_on             = [aws_iam_policy.s3bucketpolicy]
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.s3access.name
  user_data              = local.user_data_script
}

