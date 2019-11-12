resource "azurerm_resource_group" "wms" {
  name     = var.rg_name
  location = var.region
}

resource "azurerm_sql_server" "wms" {
  name                = "vbr-wms"
  resource_group_name = azurerm_resource_group.wms.name
  location            = var.region
  version             = "12.0"

  administrator_login          = var.sa_user
  administrator_login_password = var.sa_pass

  tags = {
    Name        = "WMS SQL Server // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "azurerm_sql_database" "wms" {
  name                = var.db_name
  resource_group_name = azurerm_resource_group.wms.name
  location            = var.region
  server_name         = azurerm_sql_server.wms.name

  edition                          = var.db_edition
  collation                        = "SQL_LATIN1_GENERAL_CP1_CI_AS"
  max_size_bytes                   = var.db_max_size
  requested_service_objective_name = var.db_type

  tags = {
    Name        = "WMS SQL Server Database // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "azurerm_sql_firewall_rule" "ingress_sql" {
  count = length(var.allowed_ips)

  name                = element(split("|", element(var.allowed_ips, count.index)), 1)
  resource_group_name = azurerm_resource_group.wms.name
  server_name         = azurerm_sql_server.wms.name
  start_ip_address    = element(split("|", element(var.allowed_ips, count.index)), 0)
  end_ip_address      = element(split("|", element(var.allowed_ips, count.index)), 0)
}

resource "aws_route53_record" "wms" {
  zone_id = var.public_zone_id
  type    = "CNAME"
  name    = "wms"
  ttl     = "60"
  records = ["${azurerm_sql_server.wms.fully_qualified_domain_name}"]
}
