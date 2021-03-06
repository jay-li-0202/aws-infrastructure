[
  {
    "name": "${app_name}-legacy",
    "image": "${legacy_api_image}",
    "essential": true,
    "networkMode": "awsvpc",
    "environment" : [
      { "name": "ASPNETCORE_ENVIRONMENT", "value": "${environment_name}" },

      { "name": "ConnectionStrings__Events", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__LegacyProjections", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__LegacyProjectionsAdmin", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__SyndicationProjections", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__SyndicationProjectionsAdmin", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },

      { "name": "DataDog__Enabled", "value": "true" },
      { "name": "DataDog__Debug", "value": "false" },
      { "name": "DataDog__ServiceName", "value": "${app_name}-legacy" },
      { "name": "DataDog__HostIp", "value": "localhost" },

      { "name": "Cors__0", "value": "http://localhost:3000" },
      { "name": "Cors__1", "value": "http://localhost:5000" },

      { "name": "Naamruimte", "value": "https://data.vlaanderen.be/id/adres" },
      { "name": "PostInfoNaamruimte", "value": "https://data.vlaanderen.be/id/postinfo" },
      { "name": "GemeenteNaamruimte", "value": "https://data.vlaanderen.be/id/gemeente" },
      { "name": "StraatNaamNaamruimte", "value": "https://data.vlaanderen.be/id/straatnaam" },

      { "name": "DetailUrl", "value": "https://api.${alias_zone_name}/v1/adressen/{0}" },
      { "name": "VolgendeUrl", "value": "https://api.${alias_zone_name}/v1/adressen?offset={0}&limit={1}" },
      { "name": "CrabHuisnummersVolgendeUrl", "value": "https://api.${alias_zone_name}/v1/crabhuisnummers?offset={0}&limit={1}" },
      { "name": "CrabSubadressenVolgendeUrl", "value": "https://api.${alias_zone_name}/v1/crabsubadressen?offset={0}&limit={1}" },
      { "name": "PostInfoDetailUrl", "value": "https://api.${alias_zone_name}/v1/postinfo/{0}" },
      { "name": "GemeenteDetailUrl", "value": "https://api.${alias_zone_name}/v1/gemeenten/{0}" },
      { "name": "StraatnaamDetailUrl", "value": "https://api.${alias_zone_name}/v1/straatnamen/{0}" },
      { "name": "GebouweenheidDetailUrl", "value": "https://api.${alias_zone_name}/v1/gebouweenheden/{0}" },
      { "name": "PerceelDetailUrl", "value": "https://api.${alias_zone_name}/v1/percelen/{0}" },

      { "name": "SimilarityThreshold", "value": "75.0" },
      { "name": "MaxStreetNamesThreshold", "value": "100" },

      { "name": "Syndication__Category", "value": "https://data.vlaanderen.be/ns/adres" },
      { "name": "Syndication__Id", "value": "https://api.${alias_zone_name}/v1/feeds/adressen.atom" },
      { "name": "Syndication__Self", "value": "https://api.${alias_zone_name}/syndication/feed/address.atom" },
      { "name": "Syndication__NextUri", "value": "https://api.${alias_zone_name}/v1/feeds/adressen.atom?offset={0}&limit={1}" },
      { "name": "Syndication__Related__0", "value": "https://api.${alias_zone_name}" }
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
        "containerPort": ${legacy_port},
        "hostPort": ${legacy_port}
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
    "name": "${app_name}-extract",
    "image": "${extract_api_image}",
    "essential": true,
    "networkMode": "awsvpc",
    "environment" : [
      { "name": "ASPNETCORE_ENVIRONMENT", "value": "${environment_name}" },

      { "name": "ConnectionStrings__Events", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__ExtractProjections", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__ExtractProjectionsAdmin", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__SyndicationProjections", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__SyndicationProjectionsAdmin", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },

      { "name": "DataDog__Enabled", "value": "true" },
      { "name": "DataDog__Debug", "value": "false" },
      { "name": "DataDog__ServiceName", "value": "${app_name}-extract" },
      { "name": "DataDog__HostIp", "value": "localhost" },

      { "name": "Cors__0", "value": "http://localhost:3000" },
      { "name": "Cors__1", "value": "http://localhost:5000" }
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
        "containerPort": ${extract_port},
        "hostPort": ${extract_port}
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
