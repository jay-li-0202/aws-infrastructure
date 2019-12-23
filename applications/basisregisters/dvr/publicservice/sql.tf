data "template_file" "sql1" {
  template = file("${path.module}/../../sql/01-create-db.sql")

  vars = {
    database = var.db_name
  }
}

data "template_file" "sql2" {
  template = file("${path.module}/../../sql/02-create-schema.sql")

  vars = {
    database = var.db_name
    registry = "PublicServiceRegistry"
  }
}

data "template_file" "sql3" {
  template = file("${path.module}/../../sql/03-create-user.sql")

  vars = {
    database = var.db_name
    user     = var.db_user
    password = var.db_password
  }
}

resource "null_resource" "db_setup" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command     = "sqlcmd -S tcp:127.0.0.1,${var.sql_port} -U ${var.sa_user} -P ${var.sa_pass} -q \"${data.template_file.sql1.rendered}\""
    interpreter = ["bash", "-c"]
    on_failure  = "continue"
  }

  provisioner "local-exec" {
    command     = "sqlcmd -S tcp:127.0.0.1,${var.sql_port} -U ${var.sa_user} -P ${var.sa_pass} -q \"${data.template_file.sql2.rendered}\""
    interpreter = ["bash", "-c"]
    on_failure  = "continue"
  }

  provisioner "local-exec" {
    command     = "sqlcmd -S tcp:127.0.0.1,${var.sql_port} -U ${var.sa_user} -P ${var.sa_pass} -q \"${data.template_file.sql3.rendered}\""
    interpreter = ["bash", "-c"]
    on_failure  = "continue"
  }
}
