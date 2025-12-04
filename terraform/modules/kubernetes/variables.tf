variable "namespace_name" {
  description = "Kubernetes namespace name"
  type        = string
  default     = "wopi-services"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "db_address" {
  description = "Database hostname"
  type        = string
}

variable "db_port" {
  description = "Database port"
  type        = number
}

variable "db_endpoint" {
  description = "Database endpoint"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password_secret_arn" {
  description = "ARN of the database password secret"
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