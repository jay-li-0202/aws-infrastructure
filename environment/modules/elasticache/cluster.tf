resource "aws_elasticache_replication_group" "elasticache" {
  replication_group_id = lower(
    substr(
      var.redis_cluster_id,
      0,
      min(20, length(var.redis_cluster_id)),
    ),
  )
  replication_group_description = "Redis Cluster // ${var.environment_label} ${var.environment_name}"

  apply_immediately = true

  engine               = "redis"
  engine_version       = var.redis_version
  node_type            = var.node_instance_type
  port                 = var.redis_port
  parameter_group_name = var.redis_parameter_group

  snapshot_retention_limit = var.redis_snapshot_retention_limit
  snapshot_window          = var.redis_snapshot_window

  maintenance_window = var.redis_maintenance_window

  subnet_group_name          = aws_elasticache_subnet_group.elasticache.name
  automatic_failover_enabled = true

  auto_minor_version_upgrade = true

  security_group_ids = [aws_security_group.elasticache.id]

  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = var.node_instance_count
  }

  tags = {
    Name   = "Redis Cluster // ${var.environment_label} ${var.environment_name}"
    Domain = var.domain_name
    DomainNormalized = lower(
      substr(
        var.redis_cluster_id,
        0,
        min(20, length(var.redis_cluster_id)),
      ),
    )
    Environment = var.tag_environment
    Productcode = var.tag_product
    Programma   = var.tag_program
    Contact     = var.tag_contact
  }
}

resource "aws_elasticache_subnet_group" "elasticache" {
  name        = "${lower(replace(var.environment_label, " ", "-"))}-${lower(replace(var.environment_name, " ", "-"))}-cache-subnet"
  description = "Redis Cluster Subnets // ${var.environment_label} ${var.environment_name}"
  subnet_ids  = var.subnet_ids
}
