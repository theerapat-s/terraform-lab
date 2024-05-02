# ---------------------------------------------
# Application Load Balancer (Public)
# ---------------------------------------------

resource "aws_lb" "alb_public_web" {

  name = "alb-${var.owner}-web"

  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_public_web_sg.id]
  subnets            = [var.pub_subnet_id_a, var.pub_subnet_id_b]

}

resource "aws_lb_listener" "alb_public_web_listen" {

  load_balancer_arn = aws_lb.alb_public_web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Forbidden"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "alb_public_web_listen" {

  listener_arn = aws_lb_listener.alb_public_web_listen.arn
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_public_web_tg.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

resource "aws_lb_target_group" "alb_public_web_tg" {

  name = "alb-tg-${var.owner}-ec2"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path     = "/"
    protocol = "HTTPS"
    matcher  = "200-403"
  }
}

resource "aws_lb_target_group_attachment" "web_server_a" {

  target_group_arn = aws_lb_target_group.alb_public_web_tg.arn
  target_id        = aws_instance.server-1.id
  port = 80

}

resource "aws_lb_target_group_attachment" "web_server_b" {
  target_group_arn = aws_lb_target_group.alb_public_web_tg.arn
  target_id        = aws_instance.server-2.id
  port = 80
}

# ---------------------------------------------
# Security Group
# ---------------------------------------------

resource "aws_security_group" "alb_public_web_sg" {

  name   = "securitygroup-${var.owner}-alb-public"
  vpc_id = var.vpc_id

  tags = {
    Name = "securitygroup-${var.owner}-alb-public"
  }

}


resource "aws_security_group_rule" "alb_public_web_sg_ingress_443" {

  description = "Allow connection from Cloudfront"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_public_web_sg.id
  to_port           = 80
  type              = "ingress"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.cloudfront.id]

}

resource "aws_security_group_rule" "alb_public_sg_egress" {

  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.cloudfront.id]
  security_group_id = aws_security_group.alb_public_web_sg.id
}

resource "aws_security_group_rule" "alb_public_sg_egress_local" {

  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = aws_security_group.alb_public_web_sg.id
}