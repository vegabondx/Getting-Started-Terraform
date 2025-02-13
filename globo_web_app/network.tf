
##################################################################################
# DATA
##################################################################################
data "aws_availability_zones" "available" {
  state = "available"
}
# Addressing VPC Module which provides VPC Subnets and Routing
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version = "~>4.0"

  name = "${var.prefix}-vpc"
  cidr = var.vpc_cidr_block

  azs            = slice(data.aws_availability_zones.available, 0, var.vpc_public_subnet_count)
  public_subnets = [for az in range(0, var.vpc_public_subnet_count) : cidrsubnet(var.vpc_cidr_block, 8, az)]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  enable_dns_hostnames    = true
  map_public_ip_on_launch = true

  tags = local.common_tags
}
##################################################################################
# RESOURCES
##################################################################################





# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx_sg" {
  name   = "${var.prefix}-nginx_sg"
  vpc_id = module.vpc.vpc_id

  # HTTP access from anywhere
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb_sg.id]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg" {
  name   = "${var.prefix}-alb_sg"
  vpc_id = module.vpc.vpc_id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

