[
  {
    "name": "${app_name}",
    "image": "${image}",
    "essential": true,
    "cpu": ${cpu},
    "memory": ${memory},
    "networkMode": "awsvpc",
    "environment" : [
      { "name": "ASPNETCORE_ENVIRONMENT", "value": "${environment_name}" },

      { "name": "BaseUrl", "value": "https://public-api.${public_zone_name}/" },

      { "name": "Redis__Enabled", "value": "false" },
      { "name": "Redis__ClientName", "value": "Legacy - API" },
      { "name": "Redis__ConnectionString", "value": "cache.${private_zone_name}" },

      { "name": "DataDog__Enabled", "value": "false" },

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
