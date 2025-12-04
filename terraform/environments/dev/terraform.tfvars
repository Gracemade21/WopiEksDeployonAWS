environment        = "dev"
cluster_name       = "test-app-cluster"
kubernetes_version = "1.33"
aws_region         = "us-east-2"
vpc_id             = "vpc-0904869f7d4019d18"
private_subnet_ids = ["subnet-048742a3c8dd5a91a", "subnet-0291efa03f8c2438d"]
vpc_cidr           = "10.0.0.0/16"
log_retention_days = 14

# Database
db_allocated_storage       = 20
db_max_allocated_storage   = 100
db_engine_version          = "15.00.4365.2.v1"
db_instance_class          = "db.t3.micro"
db_backup_retention_period = 7
db_backup_window           = "03:00-04:00"
db_maintenance_window      = "Sun:04:00-Sun:05:00"
skip_final_snapshot        = true
deletion_protection        = false

# Redis
redis_node_type          = "cache.t3.micro"
redis_parameter_group    = "default.redis7"
redis_num_cache_clusters = 1

tags = {
  Environment = "dev"
  Team        = "Platform"
}
