output "primary_endpoint_address" {
  description = "Primary endpoint for the Redis replication group"
  value       = aws_elasticache_replication_group.wopi.primary_endpoint_address
}

output "configuration_endpoint_address" {
  description = "Configuration endpoint for Redis"
  value       = aws_elasticache_replication_group.wopi.configuration_endpoint_address
}

output "port" {
  description = "Port number for Redis"
  value       = aws_elasticache_replication_group.wopi.port
}

output "replication_group_id" {
  description = "ID of the replication group"
  value       = aws_elasticache_replication_group.wopi.id
}

output "security_group_id" {
  description = "ID of the Redis security group"
  value       = aws_security_group.redis.id
}