resource "aws_lb" "nlb" {
  name               = var.nlb_name
  load_balancer_type = "network"
  subnets            = var.subnet_ids
  security_groups    = [var.nlb_sg_id]
}

resource "aws_lb_target_group" "nlb_tg_https" {
  name        = var.tg_name
  port        = 10443
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled = true 
    protocol = "TCP"
    port = 10443
  }

}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg_https.arn
  }
}

resource "aws_lb_target_group" "nlb_http_tg" {
  name        = var.nlb_http_tg_name
  port        = 10080
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled = true 
    protocol = "TCP"
    port = 10080
  }
}

resource "aws_lb_listener" "nlb_http_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_http_tg.arn
  }
}
