########## ASG
resource "aws_security_group" "ecs_sg" {
  name   = "${local.resource_prefix}-asg-sg"
  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_security_group_rule" "allow_port_80_ingress_from_lb" {
  security_group_id        = aws_security_group.ecs_sg.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_lb_sg.id
}

resource "aws_security_group_rule" "allow_port_22_ingress_for_ssh" {
  count                    = var.allow_ssh ? 1 : 0
  security_group_id        = aws_security_group.ecs_sg.id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_asg_all_egress" {
  security_group_id = aws_security_group.ecs_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

########## ECS_LB
resource "aws_security_group" "ecs_lb_sg" {
  name   = "${local.resource_prefix}-lb-sg"
  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_security_group_rule" "allow_lb_port_80_ingress" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ecs_lb_sg.id
}

resource "aws_security_group_rule" "allow_lb_all_egress" {
  security_group_id = aws_security_group.ecs_lb_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
