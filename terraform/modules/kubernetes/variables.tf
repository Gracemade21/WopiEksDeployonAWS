variable "namespace_name" {
  description = "Kubernetes namespace name"
  type        = string
  default     = "wopi-services"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

# External database variables
variable "db_host" {
  description = "Database hostname (geo DNS alias)"
  type        = string
}

variable "db_port" {
  description = "Database port"
  type        = number
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "connection_string" {
  description = "Full database connection string"
  type        = string
  sensitive   = true
}

variable "db_secret_arn" {
  description = "ARN of the database credentials secret"
  type        = string
  sensitive   = true
}

variable "redis_host" {
  description = "Redis host"
  type        = string
}

variable "redis_port" {
  description = "Redis port"
  type        = number
}

variable "redis_endpoint" {
  description = "Redis endpoint (for cluster mode)"
  type        = string
}