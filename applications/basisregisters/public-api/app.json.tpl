[
  {
    "name": "${app_name}",
    "image": "${image}",
    "essential": true,
    "networkMode": "awsvpc",
    "environment" : [
      { "name": "ASPNETCORE_ENVIRONMENT", "value": "${environment_name}" },

      { "name": "BaseUrl", "value": "https://api.${public_zone_name}/" },

      { "name": "Redis__Enabled", "value": "false" },
      { "name": "Redis__ClientName", "value": "Legacy - API" },
      { "name": "Redis__ConnectionString", "value": "cache.${private_zone_name}" },

      { "name": "DataDog__Enabled", "value": "true" },
      { "name": "DataDog__Debug", "value": "false" },
      { "name": "DataDog__ServiceName", "value": "${app_name}" },
      { "name": "DataDog__HostIp", "value": "localhost" },

      { "name": "ApiConfiguration__MunicipalityRegistry__ApiUrl", "value": "http://${disco_namespace}-municipality-registry-api.${disco_zone_name}:2002/v1" },
      { "name": "ApiConfiguration__MunicipalityRegistry__UseCache", "value": "false" },
      { "name": "ApiConfiguration__MunicipalityRegistry__Naamruimte", "value": "https://data.vlaanderen.be/id/gemeente" },
      { "name": "ApiConfiguration__MunicipalityRegistry__DetailUrl", "value": "https://api.${public_zone_name}/v1/gemeenten/{0}" },
      { "name": "ApiConfiguration__MunicipalityRegistry__VolgendeUrl", "value": "https://api.${public_zone_name}/v1/gemeenten?offset={0}&limit={1}" },
      { "name": "ApiConfiguration__MunicipalityRegistry__Syndication__NextUri", "value": "https://api.${public_zone_name}/v1/feeds/gemeenten.atom?offset={0}&limit={1}" },

      { "name": "ApiConfiguration__PostalRegistry__ApiUrl", "value": "http://${disco_namespace}-postal-registry-api.${disco_zone_name}:3002/v1" },
      { "name": "ApiConfiguration__PostalRegistry__UseCache", "value": "false" },
      { "name": "ApiConfiguration__PostalRegistry__Naamruimte", "value": "https://data.vlaanderen.be/id/postinfo" },
      { "name": "ApiConfiguration__PostalRegistry__DetailUrl", "value": "https://api.${public_zone_name}/v1/postinfo/{0}" },
      { "name": "ApiConfiguration__PostalRegistry__VolgendeUrl", "value": "https://api.${public_zone_name}/v1/postinfo?offset={0}&limit={1}" },
      { "name": "ApiConfiguration__PostalRegistry__Syndication__NextUri", "value": "https://api.${public_zone_name}/v1/feeds/postinfo.atom?offset={0}&limit={1}" },

      { "name": "ApiConfiguration__StreetNameRegistry__ApiUrl", "value": "http://${disco_namespace}-streetname-registry-api.${disco_zone_name}:4002/v1" },
      { "name": "ApiConfiguration__StreetNameRegistry__UseCache", "value": "false" },
      { "name": "ApiConfiguration__StreetNameRegistry__Naamruimte", "value": "https://data.vlaanderen.be/id/straatnaam" },
      { "name": "ApiConfiguration__StreetNameRegistry__GemeenteNaamruimte", "value": "https://data.vlaanderen.be/id/gemeente" },
      { "name": "ApiConfiguration__StreetNameRegistry__DetailUrl", "value": "https://api.${public_zone_name}/v1/straatnamen/{0}" },
      { "name": "ApiConfiguration__StreetNameRegistry__GemeenteDetailUrl", "value": "https://api.${public_zone_name}/v1/gemeenten/{0}" },
      { "name": "ApiConfiguration__StreetNameRegistry__VolgendeUrl", "value": "https://api.${public_zone_name}/v1/straatnamen?offset={0}&limit={1}" },
      { "name": "ApiConfiguration__StreetNameRegistry__Syndication__NextUri", "value": "https://api.${public_zone_name}/v1/feeds/straatnamen.atom?offset={0}&limit={1}" },

      { "name": "ApiConfiguration__AddressRegistry__ApiUrl", "value": "http://${disco_namespace}-address-registry-api.${disco_zone_name}:5002/v1" },
      { "name": "ApiConfiguration__AddressRegistry__UseCache", "value": "false" },
      { "name": "ApiConfiguration__AddressRegistry__Naamruimte", "value": "https://data.vlaanderen.be/id/adres" },
      { "name": "ApiConfiguration__AddressRegistry__GemeenteNaamruimte", "value": "https://data.vlaanderen.be/id/gemeente" },
      { "name": "ApiConfiguration__AddressRegistry__PostInfoNaamruimte", "value": "https://data.vlaanderen.be/id/postinfo" },
      { "name": "ApiConfiguration__AddressRegistry__StraatNaamNaamruimte", "value": "https://data.vlaanderen.be/id/straatnaam" },
      { "name": "ApiConfiguration__AddressRegistry__DetailUrl", "value": "https://api.${public_zone_name}/v1/adressen/{0}" },
      { "name": "ApiConfiguration__AddressRegistry__GemeenteDetailUrl", "value": "https://api.${public_zone_name}/v1/gemeenten/{0}" },
      { "name": "ApiConfiguration__AddressRegistry__PostInfoDetailUrl", "value": "https://api.${public_zone_name}/v1/postinfo/{0}" },
      { "name": "ApiConfiguration__AddressRegistry__StraatnaamDetailUrl", "value": "https://api.${public_zone_name}/v1/straatnamen/{0}" },
      { "name": "ApiConfiguration__AddressRegistry__VolgendeUrl", "value": "https://api.${public_zone_name}/v1/adressen?offset={0}&limit={1}" },
      { "name": "ApiConfiguration__AddressRegistry__Syndication__NextUri", "value": "https://api.${public_zone_name}/v1/feeds/adressen.atom?offset={0}&limit={1}" },

      { "name": "ApiConfiguration__BuildingRegistry__ApiUrl", "value": "http://${disco_namespace}-building-registry-api.${disco_zone_name}:6002/v1" },
      { "name": "ApiConfiguration__BuildingRegistry__UseCache", "value": "false" },

      { "name": "ApiConfiguration__ParcelRegistry__ApiUrl", "value": "http://${disco_namespace}-parcel-registry-api.${disco_zone_name}:7002/v1" },
      { "name": "ApiConfiguration__ParcelRegistry__UseCache", "value": "false" },
      { "name": "ApiConfiguration__ParcelRegistry__Naamruimte", "value": "https://data.vlaanderen.be/id/perceel" },
      { "name": "ApiConfiguration__ParcelRegistry__DetailUrl", "value": "https://api.${public_zone_name}/v1/percelen/{0}" },
      { "name": "ApiConfiguration__ParcelRegistry__AdresDetailUrl", "value": "https://api.${public_zone_name}/v1/adressen/{0}" },
      { "name": "ApiConfiguration__ParcelRegistry__VolgendeUrl", "value": "https://api.${public_zone_name}/v1/percelen?offset={0}&limit={1}" },
      { "name": "ApiConfiguration__ParcelRegistry__Syndication__NextUri", "value": "https://api.${public_zone_name}/v1/feeds/percelen.atom?offset={0}&limit={1}" },

      { "name": "ApiConfiguration__PublicServiceRegistry__ApiUrl", "value": "http://${disco_namespace}-publicservice-registry-api.${disco_zone_name}:8002/v1" },
      { "name": "ApiConfiguration__PublicServiceRegistry__UseCache", "value": "false" }
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
