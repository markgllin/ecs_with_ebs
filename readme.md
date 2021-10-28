# ECS with EBS volumes in Terraform

This repo demonstrates how to mount EBS volumes to an ECS on EC2 cluster.

It Terraform to deploy the following resources to AWS:
- An ECS cluster with related service and task definitions containing a [Hello World container](https://github.com/markgllin/docker-python-flask-helloworld)
- An autoscaling group that installs the [REX-Ray](https://rexray.readthedocs.io/en/stable/) plugin in EC2 instances to mount EBS volumes to containers

# Usage
## Requirements
- An AWS account
- Terraform

## Deploy
1. ensure your AWS credentials are exported or present in `~./aws/credentials`
2. clone the repo locally
3. `terraform init`
4. `terraform apply`

## Output
Once `terraform apply` is complete, the output will be similar to the following:

```
Apply complete! Resources: 28 added, 0 changed, 0 destroyed.

Outputs:

instance_ip_addr = "ecs-ebs-us-west-2-lb-191591323.us-west-2.elb.amazonaws.com"
```

`instance_ip_addr` corresponds to the A record of the application loadbalancer. To view the webserver, paste the value into a browser (make sure it's `http://`)

## Verifying the EBS volume has been mounted
To verify that the EBS volume has been mounted, you can confirm in the AWS console that it's been attached:

![Screen Shot 2021-10-28 at 1 49 52 PM](https://user-images.githubusercontent.com/10660708/139327004-63ca587b-f034-40b5-8599-1e630c95f899.png)

To take the extra step and verify that data persists between new tasks/EC2 instances, you can do the following:
1. ssh into the EC2 instance. This requires a key-pair to already be created and `allow_ssh=true` and `ssh_key_name=<key_pair_name>` to be set in `variables.tf`
    ```
    ssh -i <identity-file> ec2-user@<instance's public dns>
    ```
2. Retrieve the id of the running container w/ `docker ps`
3. `exec` into the container
    ```
    docker exec -it <container_id> /bin/sh
    ```
4. create a file in our mount from within the volume
    ```
    echo "blahblah" > /mnt/ecs-ebs-vl/file.txt
    ```
5. Exit and respin the task definition or EC2 instance.

If all goes well, our new task definition will automatically mount the existing EBS volume and the file we created will still be present.

