variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
}

# External Database Variables
variable "db_secret_name" {
  description = "Name of AWS Secrets Manager secret containing database credentials"
  type        = string
  default     = "wopi/database/credentials"
}

variable "db_host" {
  description = "Database host (geo DNS alias for SQL Server AG)"
  type        = string
  default     = "db-wopi"
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 1433
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "wopi"
}

# Redis Variables
variable "redis_node_type" {
  description = "The compute and memory capacity of the nodes in the Redis cluster"
  type        = string
}

variable "redis_parameter_group" {
  description = "The name of the parameter group to associate with this replication group"
  type        = string
}

variable "redis_num_cache_clusters" {
  description = "The number of cache clusters this replication group will have"
  type        = number
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
