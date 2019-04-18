[
  {
    "name": "${app_name}",
    "image": "${image}",
    "essential": true,
    "networkMode": "awsvpc",
    "environment" : [
      { "name": "ASPNETCORE_ENVIRONMENT", "value": "${environment_name}" },

      { "name": "BaseUrl", "value": "https://public-api.${public_zone_name}/" },

      { "name": "Redis__Enabled", "value": "false" },
      { "name": "Redis__ClientName", "value": "Legacy - API" },
      { "name": "Redis__ConnectionString", "value": "cache.${private_zone_name}" },

      { "name": "DataDog__Enabled", "value": "true" },
      { "name": "DataDog__Debug", "value": "false" },
      { "name": "DataDog__ServiceName", "value": "${app_name}" },
      { "name": "DataDog__HostIp", "value": "localhost" },

      { "name": "ApiConfiguration__MunicipalityRegistry__ApiUrl", "value": "https://legacy.gemeente.${disco_zone_name}/v1" },
      { "name": "ApiConfiguration__MunicipalityRegistry__UseCache", "value": "true" },
      { "name": "ApiConfiguration__MunicipalityRegistry__DetailUrl", "value": "https://api.${public_zone_name}/v1/gemeenten/{0}" },
      { "name": "ApiConfiguration__MunicipalityRegistry__VolgendeUrl", "value": "https://api.${public_zone_name}/v1/gemeenten?offset={0}&limit={1}" },

      { "name": "ApiConfiguration__PostalRegistry__ApiUrl", "value": "https://legacy.postinfo.${disco_zone_name}/v1" },
      { "name": "ApiConfiguration__PostalRegistry__UseCache", "value": "false" },
      { "name": "ApiConfiguration__PostalRegistry__DetailUrl", "value": "https://api.${public_zone_name}/v1/postinfo/{0}" },
      { "name": "ApiConfiguration__PostalRegistry__VolgendeUrl", "value": "https://api.${public_zone_name}/v1/postinfo?offset={0}&limit={1}" },

      { "name": "ApiConfiguration__StreetNameRegistry__ApiUrl", "value": "https://legacy.straatnaam.${disco_zone_name}/v1" },
      { "name": "ApiConfiguration__StreetNameRegistry__UseCache", "value": "true" },
      { "name": "ApiConfiguration__StreetNameRegistry__DetailUrl", "value": "https://api.${public_zone_name}/v1/straatnamen/{0}" },
      { "name": "ApiConfiguration__StreetNameRegistry__VolgendeUrl", "value": "https://api.${public_zone_name}/v1/straatnamen?offset={0}&limit={1}" },

      { "name": "ApiConfiguration__AddressRegistry__ApiUrl", "value": "https://legacy.adres.${disco_zone_name}/v1" },
      { "name": "ApiConfiguration__AddressRegistry__UseCache", "value": "true" },
      { "name": "ApiConfiguration__AddressRegistry__DetailUrl", "value": "https://api.${public_zone_name}/v1/adressen/{0}" },
      { "name": "ApiConfiguration__AddressRegistry__VolgendeUrl", "value": "https://api.${public_zone_name}/v1/adressen?offset={0}&limit={1}" },

      { "name": "ApiConfiguration__PublicServiceRegistry__ApiUrl", "value": "https://dienstverlening.${disco_zone_name}/api/v1/" },
      { "name": "ApiConfiguration__PublicServiceRegistry__UseCache", "value": "true" }
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
        "containerPort": ${port},
        "hostPort": ${port}
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/task/${app_name}",
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
      { "name": "DD_HOSTNAME", "value": "${app_name}" },
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
          "awslogs-group": "/ecs/task/${app_name}-datadog",
          "awslogs-region": "${region}",
          "awslogs-stream-prefix": "ecs"
        }
    }
  }
]
