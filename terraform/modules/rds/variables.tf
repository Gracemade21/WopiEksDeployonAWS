variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "The upper limit for auto-scaling storage"
  type        = number
  default     = 100
}

variable "db_engine_version" {
  description = "The engine version for SQL Server Express"
  type        = string
  default     = "15.00.4365.2.v1"
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_backup_retention_period" {
  description = "The days to retain backups"
  type        = number
  default     = 7
}

variable "db_backup_window" {
  description = "The daily time range for automated backups"
  type        = string
  default     = "03:00-04:00"
}

variable "db_maintenance_window" {
  description = "The window to perform maintenance"
  type        = string
  default     = "Sun:04:00-Sun:05:00"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}