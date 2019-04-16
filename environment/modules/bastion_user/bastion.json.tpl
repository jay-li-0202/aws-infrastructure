[
  {
    "name": "${app_name}",
    "image": "${image}",
    "essential": true,
    "cpu": ${cpu},
    "memory": ${memory},
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": 22,
        "hostPort": 22
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
