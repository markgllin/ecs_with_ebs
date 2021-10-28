[
  {
    "essential": true,
    "memory": 100,
    "name": "${container_name}",
    "cpu": 1,
    "image": "${image}",
    "environment": [],
    "portMappings": [
      {
        "hostPort": 80,
        "containerPort": ${container_port}
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "${source_volume}",
        "containerPath": "${container_path}"
      }
    ]
  }
]
