environment        = "dev"
cluster_name       = "test-app-cluster"
kubernetes_version = "1.33"
aws_region         = "us-east-2"
vpc_id             = "vpc-0904869f7d4019d18"
private_subnet_ids = ["subnet-048742a3c8dd5a91a", "subnet-0291efa03f8c2438d"]
vpc_cidr           = "10.0.0.0/16"
log_retention_days = 14

# External Database Configuration (SQL Server AG)
db_secret_name = "wopi/database/credential-dev" # UPDATE THIS with your actual secret name
db_host        = "db-wopi"                      # Geo DNS alias for AG (ric-vmdb763/764)
db_port        = 1433
db_name        = "wopi"

# Redis
redis_node_type          = "cache.t3.micro"
redis_parameter_group    = "default.redis7"
redis_num_cache_clusters = 1

tags = {
  Environment = "dev"
  ManagedBy   = "Terraform"
}
