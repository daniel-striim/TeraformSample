# ---
# AWS DB Subnet Group
# ---
resource "aws_db_subnet_group" "striim-db-subnet-group" {
  name        = var.db_subnet_name
  description = var.description
  subnet_ids  = var.subnet_ids

  tags = merge(
    var.tags,
    {
      "Name" = var.db_subnet_name
    },
  )
}

# ---
# Aurora RDS Database Cluster
# ---
resource "aws_rds_cluster" "striim-mdr" {
  count = var.create_db_instance ? 1 : 0
  cluster_identifier = var.identifier
  engine             = var.engine
  engine_version     = var.engine_version
  database_name      = var.db_name

  # Fetch the username and password directly from locals
  master_username = local.striim_secrets["db_username"]
  master_password = local.striim_secrets["db_password"]

  vpc_security_group_ids = [aws_security_group.striim-node.id]
  db_subnet_group_name   = var.db_subnet_name

  allow_major_version_upgrade = var.allow_major_version_upgrade
  apply_immediately           = var.apply_immediately
  skip_final_snapshot         = var.skip_final_snapshot
  final_snapshot_identifier   = var.final_snapshot_identifier
  backup_retention_period     = var.backup_retention_period
  deletion_protection         = var.deletion_protection

  tags = var.tags

  depends_on = [
    aws_db_subnet_group.striim-db-subnet-group
  ]
}

# ---
# Aurora RDS Database Instance
# ---
resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.striim_db_node_count
  identifier         = "${var.db_instance_name}-${count.index}"
  cluster_identifier = aws_rds_cluster.striim-mdr[count.index].id  # Use count.index here
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.striim-mdr[count.index].engine  # Use count.index here
  engine_version     = aws_rds_cluster.striim-mdr[count.index].engine_version  # Use count.index here

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null

  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  depends_on = [
    aws_rds_cluster.striim-mdr
  ]
}
