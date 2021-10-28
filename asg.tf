data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

data "template_file" "user_data" {
  template = file("user_data.config.tpl")
  vars = {
    ECS_CLUSTER = aws_ecs_cluster.ecs_cluster.name
    EBS_REGION  = var.region
  }
}

resource "aws_launch_template" "ecs_launch_template" {
  name                   = "${local.resource_prefix}-lt"
  image_id               = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.ecs_sg.id]
  user_data              = base64encode(data.template_file.user_data.rendered)
  key_name               = var.ssh_key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_iam_ip.name
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                = "${local.resource_prefix}-asg"
  max_size            = var.max_ec2_instance_count
  min_size            = var.min_ec2_instance_count
  vpc_zone_identifier = [aws_subnet.subnet1.id]

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }
}
