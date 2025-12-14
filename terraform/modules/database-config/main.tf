# Module to configure external SQL Server database connection
# This module doesn't create the database - it manages the connection configuration

data "aws_secretsmanager_secret" "db_credentials" {
  name = var.db_secret_name
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)
  db_username    = local.db_credentials["username"]
  db_password    = local.db_credentials["password"]
  
  # Build connection string for SQL Server AG
  connection_string = "Server=${var.db_host},${var.db_port};Database=${var.db_name};User Id=${local.db_username};Password=${local.db_password};TrustServerCertificate=true;ApplicationIntent=ReadWrite;MultiSubnetFailover=True;"
}

# Output sanitized connection info (no credentials)
output "db_host" {
  description = "Database host (geo DNS alias)"
  value       = var.db_host
}

output "db_port" {
  description = "Database port"
  value       = var.db_port
}

output "db_name" {
  description = "Database name"
  value       = var.db_name
}

output "db_username" {
  description = "Database username"
  value       = local.db_username
  sensitive   = true
}

output "db_password" {
  description = "Database password"
  value       = local.db_password
  sensitive   = true
}

output "connection_string" {
  description = "Full SQL Server connection string with AG failover support"
  value       = local.connection_string
  sensitive   = true
}

output "secret_arn" {
  description = "ARN of the secrets manager secret"
  value       = data.aws_secretsmanager_secret.db_credentials.arn
}