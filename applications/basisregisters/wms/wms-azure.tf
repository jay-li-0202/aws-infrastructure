resource "azurerm_resource_group" "wms" {
  name     = "vbr-wms"
  location = "West Europe"
}

resource "azurerm_sql_server" "wms" {
  name                = "wms"
  resource_group_name = "${azurerm_resource_group.wms.name}"
  location            = "West Europe"
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
  name                = "wms"
  resource_group_name = "${azurerm_resource_group.wms.name}"
  location            = "West Europe"
  server_name         = "${azurerm_sql_server.wms.name}"

  edition                          = "" // TODO: https://docs.microsoft.com/en-us/azure/sql-database/sql-database-purchase-models
  collation                        = "SQL_LATIN1_GENERAL_CP1_CI_AS"
  max_size_bytes                   = "" // TODO: https://docs.microsoft.com/en-us/azure/sql-database/sql-database-purchase-models
  requested_service_objective_name = "" // TODO: S0, S1, S2, S3, P1, P2, P4, P6, P11

  tags = {
    Name        = "WMS SQL Server Database // ${var.environment_label} ${var.environment_name}"
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "azurerm_sql_firewall_rule" "wms" {
  name                = "wms"
  resource_group_name = "${azurerm_resource_group.wms.name}"
  server_name         = "${azurerm_sql_server.wms.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0" // TODO: Get Ips
}

resource "aws_route53_record" "wms" {
  zone_id = var.public_zone_id
  type    = "CNAME"
  name    = "wms"
  ttl     = "300"
  records = ["${azurerm_sql_server.wms.fully_qualified_domain_name}"]
}
