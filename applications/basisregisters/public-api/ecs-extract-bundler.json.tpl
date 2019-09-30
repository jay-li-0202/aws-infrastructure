[
  {
    "name": "${app_name}",
    "image": "${extract_bundler_image}",
    "essential": true,
    "networkMode": "awsvpc",
    "environment" : [
      { "name": "EXTRACTDOWNLOADURLS", "value": "http://${disco_namespace}-municipality-registry-api.${disco_zone_name}:2004/v1/extract,http://${disco_namespace}-postal-registry-api.${disco_zone_name}:3004/v1/extract,http://${disco_namespace}-streetname-registry-api.${disco_zone_name}:4004/v1/extract,http://${disco_namespace}-address-registry-api.${disco_zone_name}:5004/v1/extract,http://${disco_namespace}-building-registry-api.${disco_zone_name}:6004/v1/extract,http://${disco_namespace}-parcel-registry-api.${disco_zone_name}:7004/v1/extract" },
      { "name": "S3_BUCKET", "value": "${extract_bundler_bucket}" },
      { "name": "S3_DESTINATIONPATH", "value": "" },
      { "name": "BUNDLENAME", "value": "basisregisters" },

      { "name": "DataDog__Enabled", "value": "true" },
      { "name": "DataDog__Debug", "value": "false" },
      { "name": "DataDog__ServiceName", "value": "${app_name}" },
      { "name": "DataDog__HostIp", "value": "localhost" }
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
