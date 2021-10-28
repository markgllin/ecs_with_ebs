resource "aws_vpc" "ecs_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "ecs_ig" {
  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_route_table" "ecs_ig_rt" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_ig.id
  }
}

resource "aws_route_table_association" "ecs_rta_subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.ecs_ig_rt.id
}

resource "aws_route_table_association" "ecs_rta_subnet2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.ecs_ig_rt.id
}
  