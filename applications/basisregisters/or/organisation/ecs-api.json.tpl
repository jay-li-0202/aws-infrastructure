[
  {
    "name": "${app_name}",
    "image": "${api_image}",
    "essential": true,
    "networkMode": "awsvpc",
    "environment" : [
      { "name": "ASPNETCORE_ENVIRONMENT", "value": "${environment_name}" },

      { "name": "Infrastructure__EventStoreConnectionString", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "Infrastructure__EventStoreAdministrationConnectionString", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "Infrastructure__EventStoreCommandTimeout", "value": "3000" },

      { "name": "Configuration__ConnectionString", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },

      { "name": "SqlServer__ConnectionString", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "SqlServer__MigrationsConnectionString", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },

      { "name": "ElasticSearch__ConnectionString", "value": "https://${es_server}" },
      { "name": "ElasticSearch__User", "value": "" },
      { "name": "ElasticSearch__Pass", "value": "" },

      { "name": "DataDog__Enabled", "value": "true" },
      { "name": "DataDog__Debug", "value": "false" },
      { "name": "DataDog__ServiceName", "value": "${app_name}" },
      { "name": "DataDog__HostIp", "value": "localhost" },

      { "name": "Cors__0", "value": "https://organisatie.${public_zone_name}" },
      { "name": "Cors__1", "value": "https://organisatie.${alias_zone_name}" },

      { "name": "Toggles__ApiAvailable", "value": "True" },
      { "name": "Toggles__ApplicationAvailable", "value": "True" },

      { "name": "Api__RijksRegisterCertificatePwd", "value": "" },

      { "name": "OIDCAuth__Authority", "value": "${acm_host}/op" },
      { "name": "OIDCAuth__AuthorizationRedirectUri", "value": "https://organisatie.${public_zone_name}/oic" },
      { "name": "OIDCAuth__AuthorizationIssuer", "value": "${acm_host}/op" },
      { "name": "OIDCAuth__AuthorizationEndpoint", "value": "${acm_host}/op/v1/auth" },
      { "name": "OIDCAuth__UserInfoEndPoint", "value": "${acm_host}/op/v1/userinfo" },
      { "name": "OIDCAuth__EndSessionEndPoint", "value": "${acm_host}/op/v1/logout" },
      { "name": "OIDCAuth__JwksUri", "value": "${acm_host}/op/v1/keys" },
      { "name": "OIDCAuth__PostLogoutRedirectUri", "value": "https://organisatie.${public_zone_name}" },
      { "name": "OIDCAuth__ClientId", "value": "${acm_client_id}" },
      { "name": "OIDCAuth__ClientSecret", "value": "${acm_client_secret}" },
      { "name": "OIDCAuth__TokenEndPoint", "value": "/v1/token" },
      { "name": "OIDCAuth__JwtSharedSigningKey", "value": "${acm_shared_signing_key}" },
      { "name": "OIDCAuth__JwtIssuer", "value": "https://organisatie.${public_zone_name}" },
      { "name": "OIDCAuth__JwtAudience", "value": "https://organisatie.${public_zone_name}" },
      { "name": "OIDCAuth__Developers", "value": "92c1e998-0304-4bfd-b017-6d65d442621d" }
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
        "containerPort": ${api_port},
        "hostPort": ${api_port}
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
