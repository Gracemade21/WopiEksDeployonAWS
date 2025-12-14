environment        = "prod"
cluster_name       = "ric-wopi-prod"
kubernetes_version = "1.33"
aws_region         = "us-east-2"
vpc_id             = "vpc-0f5f44ae3d566b0d5"
private_subnet_ids = ["subnet-0f51621aa2fd90357", "subnet-064390e2d2138ff25"]
vpc_cidr           = "10.75.0.0/21"
log_retention_days = 14

# External Database Configuration (SQL Server AG)
db_secret_name = "wopi/database/credential-prod" # UPDATE THIS with your actual secret name
db_host        = "db-wopi"                       # Geo DNS alias for AG (ric-vmdb763/764)
db_port        = 1433
db_name        = "wopi"

# Redis
redis_node_type          = "cache.t3.micro"
redis_parameter_group    = "default.redis7"
redis_num_cache_clusters = 1


tags = {
  Environment = "prod"
  ManagedBy   = "Terraform"
}
