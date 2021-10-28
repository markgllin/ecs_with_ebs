output "instance_ip_addr" {
  value = aws_lb.ecs_lb.dns_name
}
