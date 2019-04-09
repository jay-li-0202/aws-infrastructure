[
  {
    "name": "${app_name}",
    "image": "${image}",
    "essential": true,
    "cpu": ${cpu},
    "memory": ${memory},
    "networkMode": "awsvpc",
    "environment" : [
      { "name": "BaseUrl", "value": "https://public-api.${public_zone_name}/" },
      { "name": "Redis__Enabled", "value": "false" }
    ],
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": ${port},
        "hostPort": ${port}
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/fargate/task/${app_name}",
          "awslogs-region": "${region}",
          "awslogs-stream-prefix": "ecs"
        }
    }
  }
]
