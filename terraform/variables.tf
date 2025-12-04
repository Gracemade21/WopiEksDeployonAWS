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

# RDS Variables
variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes for the RDS instance"
  type        = number
}

variable "db_max_allocated_storage" {
  description = "The upper limit to which Amazon RDS can automatically scale the storage"
  type        = number
}

variable "db_engine_version" {
  description = "The engine version for SQL Server Express"
  type        = string
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "db_backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
}

variable "db_backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
}

variable "db_maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created"
  type        = bool
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
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