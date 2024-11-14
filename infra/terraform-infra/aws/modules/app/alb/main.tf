resource "aws_lb" "sca" {
  name               = format("sca-alb-%s", var.name_suffix)
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  tags = { Description = "Create by terraform", GBL_PROJECT = "scs", GBL_CLASS_0 = "SERVICE", GBL_CLASS_1 = "Load Balancer", GBL_CLASS_2 = "Load Balancer"}
}
resource "aws_lb_target_group" "sca" {
  name     = format("sca-tg-%s", var.name_suffix)
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 12
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = { Description = "Create by terraform", GBL_PROJECT = "scs", GBL_CLASS_0 = "SERVICE", GBL_CLASS_1 = "Load Balancer", GBL_CLASS_2 = "Target Group"}
}

resource "aws_lb_listener" "sca" {
  load_balancer_arn = aws_lb.sca.arn
  port              = 80
  protocol          = "HTTP"
  //ssl_policy        = var.ssl_policy
  //certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sca.arn
  }
}