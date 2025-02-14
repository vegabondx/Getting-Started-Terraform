resource "aws_lb" "nginx" {
  name                       = "globo-web-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.nginx_sg.id]
  subnets                    = module.vpc.public_subnets
  depends_on                 = [module.web_bucket]
  enable_deletion_protection = false

  access_logs {
    bucket  = module.web_bucket.bucket
    prefix  = "alb-logs"
    enabled = true

  }

  tags = local.common_tags

}

resource "aws_lb_target_group" "nginx" {
  name     = "nginx-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  tags     = local.common_tags
}

resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
  tags = local.common_tags
}


resource "aws_lb_target_group_attachment" "aws-tg-attach" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx[count.index].id
  port             = 80
}

