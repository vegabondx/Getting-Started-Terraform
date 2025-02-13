
# Get data for ami
data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Saving the user data script for reuse
locals {
  user_data_script = templatefile("${path.module}/scripts/startup_script.tpl",
  { s3_bucket_name = aws_s3_bucket.s3bucket.id })
}

# INSTANCES #
resource "aws_instance" "nginx" {
  count                  = var.instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[count.index % var.vpc_public_subnet_count].id
  iam_instance_profile   = aws_iam_instance_profile.s3access.name
  depends_on             = [aws_iam_role_policy_attachment.s3attachment]
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  user_data              = local.user_data_script
  tags                   = merge(local.common_tags, { Name = "${var.prefix}-nginx-${count.index}" })
}
