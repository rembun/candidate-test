resource "aws_lb_target_group" "dashboard" {
  name        = "k8s-dashboard-tg"
  port        = 30268
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb" "k8s_nlb" {
  name               = "k8s-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public_subnet_ids
}

resource "aws_lb_listener" "dashboard" {
  load_balancer_arn = aws_lb.k8s_nlb.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashboard.arn
  }
}

resource "aws_lb_target_group_attachment" "dashboard_nodes" {
  count            = length(var.worker_private_ips)
  target_group_arn = aws_lb_target_group.dashboard.arn
  target_id        = element(var.worker_private_ips, count.index)
  port             = 30268
}

