[
  {
    "name": "${app_name}",
    "image": "${reporting_image}",
    "essential": true,
    "networkMode": "awsvpc",
    "environment" : [
      { "name": "ASPNETCORE_ENVIRONMENT", "value": "${environment_name}" },

      { "name": "Infrastructure__EventStoreConnectionString", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "Infrastructure__EventStoreAdministrationConnectionString", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },

      { "name": "SqlServer__ConnectionString", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "SqlServer__MigrationsConnectionString", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },

      { "name": "Configuration__ConnectionString", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },

      { "name": "ReportingRunner__LockTableName", "value": "__DistributedLocks__" },
      { "name": "ReportingRunner__LockLeasePeriodInMinutes", "value": "5" },
      { "name": "ReportingRunner__LockRegionEndPoint", "value": "${region}" },
      { "name": "ReportingRunner__LockAccessKeyId", "value": "${access_key}" },
      { "name": "ReportingRunner__LockAccessKeySecret", "value": "${access_secret}" },

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
