resource "aws_security_group" "rds" {
  name_prefix = "${var.cluster_name}-rds-sg"
  description = "Security group for WOPI RDS database"
  vpc_id      = var.vpc_id

  ingress {
    description = "SQL Server access from EKS"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.cluster_name}-rds-sg" })
}

resource "aws_db_subnet_group" "wopi" {
  name       = "${var.cluster_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, { Name = "${var.cluster_name}-db-subnet-group" })
}

resource "aws_iam_role" "rds_monitoring" {
  name = "${var.cluster_name}-rds-enhanced-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_instance" "wopi" {
  identifier = "${var.cluster_name}-wopi-db"

  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  engine         = "sqlserver-ex"
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  username                    = "admin"
  manage_master_user_password = true

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.wopi.name

  backup_retention_period = var.db_backup_retention_period
  backup_window           = var.db_backup_window
  maintenance_window      = var.db_maintenance_window

  skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = var.deletion_protection

  enabled_cloudwatch_logs_exports = ["error"]

  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  tags = merge(var.tags, { Name = "${var.cluster_name}-wopi-database" })
}