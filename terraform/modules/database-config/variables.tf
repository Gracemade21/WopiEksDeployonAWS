variable "db_secret_name" {
  description = "Name of the AWS Secrets Manager secret containing database credentials"
  type        = string
  default     = "wopi/database/credentials"
}

variable "db_host" {
  description = "Database host (geo DNS alias for AG)"
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}