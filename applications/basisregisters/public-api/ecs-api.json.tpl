[
  {
    "name": "${app_name}",
    "image": "${image}",
    "essential": true,
    "networkMode": "awsvpc",
    "environment" : [
      { "name": "ASPNETCORE_ENVIRONMENT", "value": "${environment_name}" },

      { "name": "SiteUrl", "value": "https://${alias_zone_name}/" },
      { "name": "BaseUrl", "value": "https://api.${alias_zone_name}/" },
      { "name": "BaseName", "value": "${environment_name}" },

      { "name": "Redis__Enabled", "value": "true" },
      { "name": "Redis__ClientName", "value": "Legacy - API" },
      { "name": "Redis__ConnectionString", "value": "cache.${private_zone_name}" },

      { "name": "Cors__0", "value": "https://${public_zone_name}" },
      { "name": "Cors__1", "value": "https://api.${public_zone_name}" },
      { "name": "Cors__2", "value": "https://${alias_zone_name}" },
      { "name": "Cors__3", "value": "https://api.${alias_zone_name}" },
      { "name": "Cors__4", "value": "http://localhost:8080" },

      { "name": "DataDog__Enabled", "value": "true" },
      { "name": "DataDog__Debug", "value": "false" },
      { "name": "DataDog__ServiceName", "value": "${app_name}" },
      { "name": "DataDog__HostIp", "value": "localhost" },

      { "name": "Extract__Region", "value": "${region}" },
      { "name": "Extract__Bucket", "value": "${extract_bundler_bucket}" },
      { "name": "Extract__DestinationPath", "value": "" },
      { "name": "Extract__BundleName", "value": "basisregisters" },
      { "name": "Extract__ExpiresInSeconds", "value": "300" },

      { "name": "ApiConfiguration__MunicipalityRegistry__ApiUrl", "value": "http://${disco_namespace}-municipality-registry-api.${disco_zone_name}:2002/v1" },
      { "name": "ApiConfiguration__MunicipalityRegistry__HealthUrl", "value": "http://${disco_namespace}-municipality-registry-api.${disco_zone_name}:2002/health" },
      { "name": "ApiConfiguration__MunicipalityRegistry__UseCache", "value": "${municipality_registry_cache}" },
      { "name": "ApiConfiguration__MunicipalityRegistry__Naamruimte", "value": "https://data.vlaanderen.be/id/gemeente" },
      { "name": "ApiConfiguration__MunicipalityRegistry__DetailUrl", "value": "https://api.${alias_zone_name}/v1/gemeenten/{0}" },
      { "name": "ApiConfiguration__MunicipalityRegistry__VolgendeUrl", "value": "https://api.${alias_zone_name}/v1/gemeenten?offset={0}&limit={1}" },
      { "name": "ApiConfiguration__MunicipalityRegistry__Syndication__NextUri", "value": "https://api.${alias_zone_name}/v1/feeds/gemeenten.atom?offset={0}&limit={1}" },

      { "name": "ApiConfiguration__PostalRegistry__ApiUrl", "value": "http://${disco_namespace}-postal-registry-api.${disco_zone_name}:3002/v1" },
      { "name": "ApiConfiguration__PostalRegistry__HealthUrl", "value": "http://${disco_namespace}-postal-registry-api.${disco_zone_name}:3002/health" },
      { "name": "ApiConfiguration__PostalRegistry__UseCache", "value": "${postal_registry_cache}" },
      { "name": "ApiConfiguration__PostalRegistry__Naamruimte", "value": "https://data.vlaanderen.be/id/postinfo" },
      { "name": "ApiConfiguration__PostalRegistry__DetailUrl", "value": "https://api.${alias_zone_name}/v1/postinfo/{0}" },
      { "name": "ApiConfiguration__PostalRegistry__VolgendeUrl", "value": "https://api.${alias_zone_name}/v1/postinfo?offset={0}&limit={1}" },
      { "name": "ApiConfiguration__PostalRegistry__Syndication__NextUri", "value": "https://api.${alias_zone_name}/v1/feeds/postinfo.atom?offset={0}&limit={1}" },

      { "name": "ApiConfiguration__StreetNameRegistry__ApiUrl", "value": "http://${disco_namespace}-streetname-registry-api.${disco_zone_name}:4002/v1" },
      { "name": "ApiConfiguration__StreetNameRegistry__HealthUrl", "value": "http://${disco_namespace}-streetname-registry-api.${disco_zone_name}:4002/health" },
      { "name": "ApiConfiguration__StreetNameRegistry__UseCache", "value": "${streetname_registry_cache}" },
      { "name": "ApiConfiguration__StreetNameRegistry__Naamruimte", "value": "https://data.vlaanderen.be/id/straatnaam" },
      { "name": "ApiConfiguration__StreetNameRegistry__GemeenteNaamruimte", "value": "https://data.vlaanderen.be/id/gemeente" },
      { "name": "ApiConfiguration__StreetNameRegistry__DetailUrl", "value": "https://api.${alias_zone_name}/v1/straatnamen/{0}" },
      { "name": "ApiConfiguration__StreetNameRegistry__GemeenteDetailUrl", "value": "https://api.${alias_zone_name}/v1/gemeenten/{0}" },
      { "name": "ApiConfiguration__StreetNameRegistry__VolgendeUrl", "value": "https://api.${alias_zone_name}/v1/straatnamen?offset={0}&limit={1}" },
      { "name": "ApiConfiguration__StreetNameRegistry__Syndication__NextUri", "value": "https://api.${alias_zone_name}/v1/feeds/straatnamen.atom?offset={0}&limit={1}" },

      { "name": "ApiConfiguration__AddressRegistry__ApiUrl", "value": "http://${disco_namespace}-address-registry-api.${disco_zone_name}:5002/v1" },
      { "name": "ApiConfiguration__AddressRegistry__HealthUrl", "value": "http://${disco_namespace}-address-registry-api.${disco_zone_name}:5002/health" },
      { "name": "ApiConfiguration__AddressRegistry__UseCache", "value": "${address_registry_cache}" },
      { "name": "ApiConfiguration__AddressRegistry__Naamruimte", "value": "https://data.vlaanderen.be/id/adres" },
      { "name": "ApiConfiguration__AddressRegistry__GemeenteNaamruimte", "value": "https://data.vlaanderen.be/id/gemeente" },
      { "name": "ApiConfiguration__AddressRegistry__PostInfoNaamruimte", "value": "https://data.vlaanderen.be/id/postinfo" },
      { "name": "ApiConfiguration__AddressRegistry__StraatNaamNaamruimte", "value": "https://data.vlaanderen.be/id/straatnaam" },
      { "name": "ApiConfiguration__AddressRegistry__DetailUrl", "value": "https://api.${alias_zone_name}/v1/adressen/{0}" },
      { "name": "ApiConfiguration__AddressRegistry__GemeenteDetailUrl", "value": "https://api.${alias_zone_name}/v1/gemeenten/{0}" },
      { "name": "ApiConfiguration__AddressRegistry__PostInfoDetailUrl", "value": "https://api.${alias_zone_name}/v1/postinfo/{0}" },
      { "name": "ApiConfiguration__AddressRegistry__StraatnaamDetailUrl", "value": "https://api.${alias_zone_name}/v1/straatnamen/{0}" },
      { "name": "ApiConfiguration__AddressRegistry__GebouweenheidDetailUrl", "value": "https://api.${alias_zone_name}/v1/gebouweenheden/{0}" },
      { "name": "ApiConfiguration__AddressRegistry__VolgendeUrl", "value": "https://api.${alias_zone_name}/v1/adressen?offset={0}&limit={1}" },
      { "name": "ApiConfiguration__AddressRegistry__Syndication__NextUri", "value": "https://api.${alias_zone_name}/v1/feeds/adressen.atom?offset={0}&limit={1}" },

      { "name": "ApiConfiguration__BuildingRegistry__ApiUrl", "value": "http://${disco_namespace}-building-registry-api.${disco_zone_name}:6002/v1" },
      { "name": "ApiConfiguration__BuildingRegistry__HealthUrl", "value": "http://${disco_namespace}-building-registry-api.${disco_zone_name}:6002/health" },
      { "name": "ApiConfiguration__BuildingRegistry__UseCache", "value": "${building_registry_cache}" },
      { "name": "ApiConfiguration__BuildingRegistry__GebouwNaamruimte", "value": "https://data.vlaanderen.be/id/gebouw" },
      { "name": "ApiConfiguration__BuildingRegistry__GebouweenheidNaamruimte", "value": "https://data.vlaanderen.be/id/gebouweenheid" },
      { "name": "ApiConfiguration__BuildingRegistry__GebouwDetailUrl", "value": "https://api.${alias_zone_name}/v1/gebouwen/{0}" },
      { "name": "ApiConfiguration__BuildingRegistry__GebouweenheidDetailUrl", "value": "https://api.${alias_zone_name}/v1/gebouweenheden/{0}" },
      { "name": "ApiConfiguration__BuildingRegistry__PerceelUrl", "value": "https://api.${alias_zone_name}/v1/percelen/{0}" },
      { "name": "ApiConfiguration__BuildingRegistry__AdresUrl", "value": "https://api.${alias_zone_name}/v1/adressen/{0}" },
      { "name": "ApiConfiguration__BuildingRegistry__GebouwVolgendeUrl", "value": "https://api.${alias_zone_name}/v1/gebouwen?offset={0}&limit={1}" },
      { "name": "ApiConfiguration__BuildingRegistry__GebouweenheidVolgendeUrl", "value": "https://api.${alias_zone_name}/v1/gebouweenheden?offset={0}&limit={1}" },
      { "name": "ApiConfiguration__BuildingRegistry__Syndication__NextUri", "value": "https://api.${alias_zone_name}/v1/feeds/gebouwen.atom?offset={0}&limit={1}" },

      { "name": "ApiConfiguration__ParcelRegistry__ApiUrl", "value": "http://${disco_namespace}-parcel-registry-api.${disco_zone_name}:7002/v1" },
      { "name": "ApiConfiguration__ParcelRegistry__HealthUrl", "value": "http://${disco_namespace}-parcel-registry-api.${disco_zone_name}:7002/health" },
      { "name": "ApiConfiguration__ParcelRegistry__UseCache", "value": "${parcel_registry_cache}" },
      { "name": "ApiConfiguration__ParcelRegistry__Naamruimte", "value": "https://data.vlaanderen.be/id/perceel" },
      { "name": "ApiConfiguration__ParcelRegistry__DetailUrl", "value": "https://api.${alias_zone_name}/v1/percelen/{0}" },
      { "name": "ApiConfiguration__ParcelRegistry__AdresDetailUrl", "value": "https://api.${alias_zone_name}/v1/adressen/{0}" },
      { "name": "ApiConfiguration__ParcelRegistry__VolgendeUrl", "value": "https://api.${alias_zone_name}/v1/percelen?offset={0}&limit={1}" },
      { "name": "ApiConfiguration__ParcelRegistry__Syndication__NextUri", "value": "https://api.${alias_zone_name}/v1/feeds/percelen.atom?offset={0}&limit={1}" },

      { "name": "ApiConfiguration__PublicServiceRegistry__ApiUrl", "value": "http://${disco_namespace}-publicservice-registry-api.${disco_zone_name}:8002/v1" },
      { "name": "ApiConfiguration__PublicServiceRegistry__HealthUrl", "value": "http://${disco_namespace}-publicservice-registry-api.${disco_zone_name}:8002/health" },
      { "name": "ApiConfiguration__PublicServiceRegistry__UseCache", "value": "${publicservice_registry_cache}" }      
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
