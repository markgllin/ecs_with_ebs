resource "aws_lb" "ecs_lb" {
  name            = "${local.resource_prefix}-lb"
  internal        = false
  subnets         = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  security_groups = [aws_security_group.ecs_lb_sg.id]
}

resource "aws_lb_listener" "ecs_lb_listener" {
  port              = "80"
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.ecs_lb.arn

  default_action {
    target_group_arn = aws_lb_target_group.ecs_lb_tg.id
    type             = "forward"
  }
}

resource "aws_lb_target_group" "ecs_lb_tg" {
  name     = "${local.resource_prefix}-lb-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.ecs_vpc.id
}
