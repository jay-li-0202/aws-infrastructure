data "template_file" "sql1" {
  template = file("${path.module}/01-create-user.sql")

  vars = {
    database = var.db_name
    user     = var.db_user
    password = var.db_password
  }
}

data "template_file" "sql2" {
  template = file("${path.module}/02-grant-permissions.sql")

  vars = {
    user = var.db_user
  }
}

data "template_file" "sql3" {
  template = file("${path.module}/03-create-schema.sql")

  vars = {
    database = var.db_name
  }
}

resource "null_resource" "db_setup" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = "sqlcmd -S tcp:127.0.0.1,10001 -U ${var.sa_user}@${azurerm_sql_server.wms.fully_qualified_domain_name} -P ${var.sa_pass} -d master -q \"${data.template_file.sql1.rendered}\""
  }

  provisioner "local-exec" {
    command = "sqlcmd -S tcp:127.0.0.1,10001 -U ${var.sa_user}@${azurerm_sql_server.wms.fully_qualified_domain_name} -P ${var.sa_pass} -d ${var.db_name} -q \"${data.template_file.sql2.rendered}\""
  }

  provisioner "local-exec" {
    command = "sqlcmd -S tcp:127.0.0.1,10001 -U ${var.sa_user}@${azurerm_sql_server.wms.fully_qualified_domain_name} -P ${var.sa_pass} -d ${var.db_name} -q \"${data.template_file.sql3.rendered}\""
  }
}
