data "template_file" "sql1" {
  template = file("${path.module}/01-create-user.sql")

  vars = {
    user     = var.db_user
    password = var.db_password
  }
}

data "template_file" "sql2" {
  template = file("${path.module}/02-grant-permissions.sql")

  vars = {
    user = var.db_user
    role = "db_owner"
  }
}

data "template_file" "sql3" {
  template = file("${path.module}/03-create-schema.sql")
}

data "template_file" "sql4" {
  template = file("${path.module}/01-create-user.sql")

  vars = {
    user     = "${var.db_user}-reader"
    password = var.db_reader_password
  }
}

data "template_file" "sql5" {
  template = file("${path.module}/02-grant-permissions.sql")

  vars = {
    user = "${var.db_user}-reader"
    role = "db_datareader"
  }
}

data "template_file" "sql6" {
  template = file("${path.module}/04-hide-reader.sql")

  vars = {
    user = "${var.db_user}-reader"
  }
}

resource "null_resource" "db_setup" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command     = "sqlcmd -S tcp:127.0.0.1,${var.sql_port} -U ${var.sa_user}@${azurerm_sql_server.wms.fully_qualified_domain_name} -P ${var.sa_pass} -d master -q \"${data.template_file.sql1.rendered}\""
    interpreter = ["bash", "-c"]
    on_failure  = continue
  }

  provisioner "local-exec" {
    command     = "sqlcmd -S tcp:127.0.0.1,${var.sql_port} -U ${var.sa_user}@${azurerm_sql_server.wms.fully_qualified_domain_name} -P ${var.sa_pass} -d ${var.db_name} -q \"${data.template_file.sql2.rendered}\""
    interpreter = ["bash", "-c"]
    on_failure  = continue
  }

  provisioner "local-exec" {
    command     = "sqlcmd -S tcp:127.0.0.1,${var.sql_port} -U ${var.sa_user}@${azurerm_sql_server.wms.fully_qualified_domain_name} -P ${var.sa_pass} -d ${var.db_name} -q \"${data.template_file.sql3.rendered}\""
    interpreter = ["bash", "-c"]
    on_failure  = continue
  }

  provisioner "local-exec" {
    command     = "sqlcmd -S tcp:127.0.0.1,${var.sql_port} -U ${var.sa_user}@${azurerm_sql_server.wms.fully_qualified_domain_name} -P ${var.sa_pass} -d master -q \"${data.template_file.sql4.rendered}\""
    interpreter = ["bash", "-c"]
    on_failure  = continue
  }

  provisioner "local-exec" {
    command     = "sqlcmd -S tcp:127.0.0.1,${var.sql_port} -U ${var.sa_user}@${azurerm_sql_server.wms.fully_qualified_domain_name} -P ${var.sa_pass} -d ${var.db_name} -q \"${data.template_file.sql5.rendered}\""
    interpreter = ["bash", "-c"]
    on_failure  = continue
  }

  provisioner "local-exec" {
    command     = "sqlcmd -S tcp:127.0.0.1,${var.sql_port} -U ${var.sa_user}@${azurerm_sql_server.wms.fully_qualified_domain_name} -P ${var.sa_pass} -d ${var.db_name} -q \"${data.template_file.sql6.rendered}\""
    interpreter = ["bash", "-c"]
    on_failure  = continue
  }
}
