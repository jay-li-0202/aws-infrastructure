[
  {
    "name": "${app_name}-site",
    "image": "${site_image}",
    "essential": true,
    "networkMode": "awsvpc",
    "environment" : [
      { "name": "API_VERSION", "value": "${site_version}" },
      { "name": "API_ENDPOINT", "value": "https://api.${public_zone_name}/" },

      { "name": "DataDog__Enabled", "value": "true" },
      { "name": "DataDog__Debug", "value": "false" },
      { "name": "DataDog__ServiceName", "value": "${app_name}-site" },
      { "name": "DataDog__HostIp", "value": "localhost" }
    ],
    "dockerLabels": {
      "environment": "${tag_environment}",
      "productcode": "${tag_product}",
      "programma": "${tag_program}",
      "contact": "${tag_contact}"
    },
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": ${site_port},
        "hostPort": ${site_port}
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/task/${logging_name}",
          "awslogs-region": "${region}",
          "awslogs-stream-prefix": "ecs"
        }
    }
  },

  {
    "name": "datadog-agent",
    "image": "datadog/agent:latest",
    "essential": true,
    "networkMode": "awsvpc",
    "command": ["sh", "-c", "echo 'expvar_port: 15000' >> /etc/datadog-agent/datadog.yaml ; /init"],
    "environment": [
      { "name": "DD_API_KEY", "value": "${datadog_api_key}" },
      { "name": "ECS_FARGATE", "value": "true" },
      { "name": "DD_APM_ENABLED", "value": "true" },
      { "name": "DD_DOGSTATSD_NON_LOCAL_TRAFFIC", "value": "true" },
      { "name": "DD_APM_NON_LOCAL_TRAFFIC", "value": "true" },
      { "name": "DD_APM_ENV", "value": "${datadog_env}" },
      { "name": "DD_TAGS", "value": "env:${datadog_env}" }
    ],
    "dockerLabels": {
      "environment": "${tag_environment}",
      "productcode": "${tag_product}",
      "programma": "${tag_program}",
      "contact": "${tag_contact}"
    },
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/task/${logging_name}-datadog",
          "awslogs-region": "${region}",
          "awslogs-stream-prefix": "ecs"
        }
    }
  }
]
