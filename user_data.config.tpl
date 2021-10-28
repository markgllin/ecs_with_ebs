#!/bin/bash
echo ECS_CLUSTER=${ECS_CLUSTER} >> /etc/ecs/ecs.config

# install the Docker volume plugin
docker plugin install rexray/ebs REXRAY_PREEMPT=true EBS_REGION=${EBS_REGION} --grant-all-permissions

# restart the ECS agent
sudo systemctl restart ecs
