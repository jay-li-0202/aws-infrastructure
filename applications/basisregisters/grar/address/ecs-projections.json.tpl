[
  {
    "name": "${app_name}",
    "image": "${projections_image}",
    "essential": true,
    "networkMode": "awsvpc",
    "environment" : [
      { "name": "ASPNETCORE_ENVIRONMENT", "value": "${environment_name}" },

      { "name": "ConnectionStrings__Events", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__LegacyProjections", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__LegacyProjectionsAdmin", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__ExtractProjections", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__ExtractProjectionsAdmin", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__LastChangedList", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__LastChangedListAdmin", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },

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
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": ${projections_port},
        "hostPort": ${projections_port}
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
    "name": "${app_name}-syndication",
    "image": "${syndication_image}",
    "essential": true,
    "networkMode": "awsvpc",
    "environment" : [
      { "name": "ASPNETCORE_ENVIRONMENT", "value": "${environment_name}" },

      { "name": "ConnectionStrings__Events", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__SyndicationProjections", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__SyndicationProjectionsAdmin", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },

      { "name": "DataDog__Enabled", "value": "true" },
      { "name": "DataDog__Debug", "value": "false" },
      { "name": "DataDog__ServiceName", "value": "${app_name}-syndication" },
      { "name": "DataDog__HostIp", "value": "localhost" },

      { "name": "SyndicationFeeds__Municipality", "value": "http://${disco_namespace}-municipality-registry-api.${disco_zone_name}:2002/v1/gemeenten/sync" },
      { "name": "SyndicationFeeds__MunicipalityPollingInMilliseconds", "value": "5000" },

      { "name": "SyndicationFeeds__StreetName", "value": "http://${disco_namespace}-streetname-registry-api.${disco_zone_name}:4002/v1/straatnamen/sync" },
      { "name": "SyndicationFeeds__StreetNamePollingInMilliseconds", "value": "5000" }
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
        "containerPort": ${syndication_port},
        "hostPort": ${syndication_port}
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
