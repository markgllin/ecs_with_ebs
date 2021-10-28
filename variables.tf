variable "region" {
  type    = string
  default = "us-west-2"
}

####### ECS Cluster ########
variable "cluster_name" {
  type        = string
  description = "Name of ECS cluster"
  default     = "ecs-ebs"
}

variable "container_port" {
  type        = string
  description = "Container port"
  default     = "80"
}


variable "container_name" {
  type        = string
  description = "Name of container in task definition"
  default     = "helloworld"
}

variable "image_url" {
  type        = string
  description = "URL of image to use in ECS"
  default     = "registry-1.docker.io/markgllin/python-flask-helloworld"
}

variable "desired_ecs_svc_count" {
  type        = number
  description = "Desired # of ECS services to spin up in ECS cluster"
  default     = 1
}

######## Autoscaling Group ########
variable "min_ec2_instance_count" {
  type        = number
  description = "Minimum # of EC2 instances in autoscaling group"
  default     = 1
}

variable "max_ec2_instance_count" {
  type        = number
  description = "Maximum # of EC2 instances in autoscaling group"
  default     = 1
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type to use in AWS Launch Configuration"
  default     = "t2.nano"
}

variable "allow_ssh" {
  type        = bool
  description = "Allow ssh access to EC2 instances"
  default     = false
}

variable "ssh_key_name" {
  type        = string
  description = "SSH Key-Pair to use. Used in conjunction with `allow_ssh`"
  default     = null
}
