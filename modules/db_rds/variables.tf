
variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "db-instance"
}

variable "engine" {
  description = "Database engine (e.g., postgres, mysql)"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance class; ensure supports high IOPS requirements"
  type        = string
  default     = "db.m5.xlarge"  # Updated to higher spec that supports high IOPS
}

variable "allocated_storage" {
  description = "Storage size in GB"
  type        = number
  default     = 100               # Increased storage for compatibility with high IOPS
}

variable "iops" {
  description = "Provisioned IOPS for storage"
  type        = number
  default     = 21000             # Required IOPS for consistent storage performance
}

variable "kms_key_id" {
  description = "KMS Key ID for storage encryption"
  type        = string
  default     = null
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "mydatabase"
}

variable "username" {
  description = "Master username"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
  default     = null
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot upon deletion"
  type        = bool
  default     = true
}

variable "security_group_ids" {
  description = "List of security group IDs to associate"
  type        = list(string)
  default     = []
}

variable "subnet_group_name" {
  description = "DB subnet group for RDS instance"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}