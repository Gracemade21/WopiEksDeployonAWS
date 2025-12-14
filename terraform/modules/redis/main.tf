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

  tags = merge(var.tags, { Name = "${var.cluster_name}-redis-sg" }, {
    CostCenter           = "CC5409"
    CustomerName         = "Hyland Software Inc"
    EnvironmentType      = "Sandbox"
    Owner                = "CPEENBL"
    Platform             = "AWS Delivery"
    Product              = "OnBase"
    git_commit           = "15f3b7df3d4213975dbf3b4c4ff4f3dc9fd9983b"
    git_file             = "wopieksdeploy/terraform/modules/redis/main.tf"
    git_last_modified_at = "2025-12-11 21:55:39"
    git_last_modified_by = "16985548+stamo57@users.noreply.github.com"
    git_modifiers        = "16985548+stamo57/nnabuife.ike"
    git_org              = "HylandSoftware"
    git_repo             = "enbl-eks-wopi-standalone-offering"
    source               = "yor"
    yor_name             = "redis"
    yor_trace            = "5f98f345-e435-4780-b2df-fae0e9ba9a30"
  })
}

resource "aws_elasticache_subnet_group" "wopi" {
  name       = "${var.cluster_name}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, { Name = "${var.cluster_name}-redis-subnet-group" }, {
    CostCenter           = "CC5409"
    CustomerName         = "Hyland Software Inc"
    EnvironmentType      = "Sandbox"
    Owner                = "CPEENBL"
    Platform             = "AWS Delivery"
    Product              = "OnBase"
    git_commit           = "15f3b7df3d4213975dbf3b4c4ff4f3dc9fd9983b"
    git_file             = "wopieksdeploy/terraform/modules/redis/main.tf"
    git_last_modified_at = "2025-12-11 21:55:39"
    git_last_modified_by = "16985548+stamo57@users.noreply.github.com"
    git_modifiers        = "16985548+stamo57/nnabuife.ike"
    git_org              = "HylandSoftware"
    git_repo             = "enbl-eks-wopi-standalone-offering"
    source               = "yor"
    yor_name             = "wopi"
    yor_trace            = "4b35a556-5c69-4534-b5d7-c0678f0ba297"
  })
}

resource "aws_cloudwatch_log_group" "redis_slow_log" {
  name              = "/aws/elasticache/redis/${var.cluster_name}-slow-log"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, { Name = "${var.cluster_name}-redis-slow-log" }, {
    CostCenter           = "CC5409"
    CustomerName         = "Hyland Software Inc"
    EnvironmentType      = "Sandbox"
    Owner                = "CPEENBL"
    Platform             = "AWS Delivery"
    Product              = "OnBase"
    git_commit           = "15f3b7df3d4213975dbf3b4c4ff4f3dc9fd9983b"
    git_file             = "wopieksdeploy/terraform/modules/redis/main.tf"
    git_last_modified_at = "2025-12-11 21:55:39"
    git_last_modified_by = "16985548+stamo57@users.noreply.github.com"
    git_modifiers        = "16985548+stamo57/nnabuife.ike"
    git_org              = "HylandSoftware"
    git_repo             = "enbl-eks-wopi-standalone-offering"
    source               = "yor"
    yor_name             = "redis_slow_log"
    yor_trace            = "690f00d2-4118-4243-9fe3-efda9a9bc923"
  })
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

  tags = merge(var.tags, { Name = "${var.cluster_name}-redis-cluster" }, {
    CostCenter           = "CC5409"
    CustomerName         = "Hyland Software Inc"
    EnvironmentType      = "Sandbox"
    Owner                = "CPEENBL"
    Platform             = "AWS Delivery"
    Product              = "OnBase"
    git_commit           = "15f3b7df3d4213975dbf3b4c4ff4f3dc9fd9983b"
    git_file             = "wopieksdeploy/terraform/modules/redis/main.tf"
    git_last_modified_at = "2025-12-11 21:55:39"
    git_last_modified_by = "16985548+stamo57@users.noreply.github.com"
    git_modifiers        = "16985548+stamo57/nnabuife.ike"
    git_org              = "HylandSoftware"
    git_repo             = "enbl-eks-wopi-standalone-offering"
    source               = "yor"
    yor_name             = "wopi"
    yor_trace            = "6679c74a-ebc7-4837-b402-cff6845f9ca8"
  })
}