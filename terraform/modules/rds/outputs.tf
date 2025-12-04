output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.wopi.endpoint
}

output "db_instance_address" {
  description = "RDS instance hostname"
  value       = aws_db_instance.wopi.address
}

output "db_instance_port" {
  description = "RDS instance port"
  value       = aws_db_instance.wopi.port
}

output "db_instance_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.wopi.identifier
}

output "db_password_secret_arn" {
  description = "ARN of the database password secret"
  value       = aws_db_instance.wopi.master_user_secret[0].secret_arn
  sensitive   = true
}

output "security_group_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds.id
}