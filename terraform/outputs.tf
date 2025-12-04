# EKS Outputs
output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_id" {
  description = "The name/id of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "The ARN of the cluster"
  value       = module.eks.cluster_arn
}

# Database Outputs
output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.db_instance_endpoint
}

output "db_instance_address" {
  description = "RDS instance hostname"
  value       = module.rds.db_instance_address
}

output "db_instance_port" {
  description = "RDS instance port"
  value       = module.rds.db_instance_port
}

# Redis Outputs
output "redis_primary_endpoint" {
  description = "Primary endpoint for the Redis replication group"
  value       = module.redis.primary_endpoint_address
}

output "redis_connection_string" {
  description = "Complete Redis connection string"
  value       = "${module.redis.primary_endpoint_address}:${module.redis.port}"
}