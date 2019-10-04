[
  {
    "name": "${app_name}",
    "image": "${api_image}",
    "essential": true,
    "networkMode": "awsvpc",
    "environment" : [
      { "name": "ASPNETCORE_ENVIRONMENT", "value": "${environment_name}" },

      { "name": "ConnectionStrings__Events", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__BackofficeProjections", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },
      { "name": "ConnectionStrings__BackofficeProjectionsAdmin", "value": "Server=${db_server};Database=${db_name};User=${db_user};Password=${db_pass};" },

      { "name": "DataDog__Enabled", "value": "true" },
      { "name": "DataDog__Debug", "value": "false" },
      { "name": "DataDog__ServiceName", "value": "${app_name}" },
      { "name": "DataDog__HostIp", "value": "localhost" },

      { "name": "Cors__0", "value": "https://dienstverlening.${public_zone_name}" },
      { "name": "Cors__1", "value": "https://dienstverlening.${alias_zone_name}" },

      { "name": "OIDCAuth__CallbackPath", "value": "/oic" },
      { "name": "OIDCAuth__TokenEndPoint", "value": "/v1/token" },
      { "name": "OIDCAuth__Authority", "value": "${acm_host}/op" },
      { "name": "OIDCAuth__JwtSharedSigningKey", "value": "${acm_shared_signing_key}" },
      { "name": "OIDCAuth__JwtCookieDurationInMinutes", "value": "1440" },
      { "name": "OIDCAuth__JwtIssuer", "value": "https://dienstverlening.${public_zone_name}" },
      { "name": "OIDCAuth__JwtAudience", "value": "https://dienstverlening.${public_zone_name}" },
      { "name": "OIDCAuth__JwtCookieDomain", "value": ".dienstverlening.${public_zone_name}" },
      { "name": "OIDCAuth__JwtCookieName", "value": "${acm_cookie_name}" },
      { "name": "OIDCAuth__SignOutReturnUrl", "value": "https://dienstverlening.${public_zone_name}" },
      { "name": "OIDCAuth__AuthorizationRedirectUri", "value": "https://dienstverlening.${public_zone_name}/oic" },
      { "name": "OIDCAuth__ClientId", "value": "${acm_client_id}" },
      { "name": "OIDCAuth__ClientSecret", "value": "${acm_client_secret}" },

      { "name": "OIDCAuthAcm__Authority", "value": "${acm_host}/op" },
      { "name": "OIDCAuthAcm__Issuer", "value": "${acm_host}/op" },
      { "name": "OIDCAuthAcm__AuthorizationEndpoint", "value": "${acm_host}/op/v1/auth" },
      { "name": "OIDCAuthAcm__UserInfoEndPoint", "value": "${acm_host}/op/v1/userinfo" },
      { "name": "OIDCAuthAcm__EndSessionEndPoint", "value": "${acm_host}/op/v1/logout" },
      { "name": "OIDCAuthAcm__JwksUri", "value": "${acm_host}/op/v1/keys" },
      { "name": "OIDCAuthAcm__ClientId", "value": "${acm_client_id}" },
      { "name": "OIDCAuthAcm__RedirectUri", "value": "https://dienstverlening.${public_zone_name}/oic" },
      { "name": "OIDCAuthAcm__PostLogoutRedirectUri", "value": "https://dienstverlening.${public_zone_name}" }
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
