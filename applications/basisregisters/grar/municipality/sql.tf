data "template_file" "sql" {
  template = "${file("${path.module}/../registry.sql")}"

  vars {
    database = "municipality-registry"
    registry = "MunicipalityRegistry"
    user     = "municipality"
    password = "${var.password}"
  }
}

resource "null_resource" "db_setup" {
  triggers {
    key = "${uuid()}"
  }

  provisioner "local-exec" {
    command = "sqlcmd -S tcp:127.0.0.1,9001 -U ${var.sa_user} -P ${var.sa_pass} -q \"${data.template_file.sql.rendered}\""
  }
}
