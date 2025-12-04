resource "aws_security_group" "redis" {
  name_prefix = "${var.cluster_name}-redis-sg"
  description = "Security group for WOPI Redis cluster"
  vpc_id      = var.vpc_id

  ingress {
    description = "Redis access from EKS"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.cluster_name}-redis-sg" })
}

resource "aws_elasticache_subnet_group" "wopi" {
  name       = "${var.cluster_name}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, { Name = "${var.cluster_name}-redis-subnet-group" })
}

resource "aws_cloudwatch_log_group" "redis_slow_log" {
  name              = "/aws/elasticache/redis/${var.cluster_name}-slow-log"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, { Name = "${var.cluster_name}-redis-slow-log" })
}

resource "aws_elasticache_replication_group" "wopi" {
  replication_group_id = "${var.cluster_name}-redis"
  description          = "Redis cluster for WOPI application"

  node_type            = var.redis_node_type
  port                 = 6379
  parameter_group_name = var.redis_parameter_group

  num_cache_clusters = var.redis_num_cache_clusters

  subnet_group_name  = aws_elasticache_subnet_group.wopi.name
  security_group_ids = [aws_security_group.redis.id]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = false

  automatic_failover_enabled = var.redis_num_cache_clusters > 1 ? true : false
  multi_az_enabled           = var.redis_num_cache_clusters > 1 ? true : false

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis_slow_log.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }

  tags = merge(var.tags, { Name = "${var.cluster_name}-redis-cluster" })
}