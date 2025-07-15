variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "minimum_password_length" {
  description = "Minimum length for IAM passwords"
  type        = number
  default     = 8
}

variable "require_uppercase_characters" {
  description = "Require uppercase letters in IAM passwords"
  type        = bool
  default     = true
}

variable "require_lowercase_characters" {
  description = "Require lowercase letters in IAM passwords"
  type        = bool
  default     = true
}

variable "require_symbols" {
  description = "Require special characters in IAM passwords"
  type        = bool
  default     = true
}

variable "require_numbers" {
  description = "Require numbers in IAM passwords"
  type        = bool
  default     = true
}

variable "max_password_age" {
  description = "Maximum password age in days before reset"
  type        = number
  default     = 90
}

variable "password_reuse_prevention" {
  description = "Number of previous passwords that cannot be reused"
  type        = number
  default     = 3
}

variable "groups" {
  description = "IAM groups configuration with names"
  type = object({
    sysadmin = object({ name = string })
    dbadmin  = object({ name = string })
    monitor  = object({ name = string })
  })
  default = {
    sysadmin = { name = "SysAdmin" }
    dbadmin  = { name = "DBAdmin" }
    monitor  = { name = "Monitor" }
  }
}

variable "users" {
  description = "Maps of IAM usernames by group"
  type = object({
    sysadmin = map(string)
    dbadmin  = map(string)
    monitor  = map(string)
  })
  default = {
    sysadmin = {
      sysadmin1 = "sysadmin1"
      sysadmin2 = "sysadmin2"
    }
    dbadmin = {
      dbadmin1 = "dbadmin1"
      dbadmin2 = "dbadmin2"
    }
    monitor = {
      monitor1 = "monitor1"
      monitor2 = "monitor2"
      monitor3 = "monitor3"
      monitor4 = "monitor4"
    }
  }
}

variable "ec2_role" {
  description = "EC2 IAM role configuration"
  type = object({
    name = string
  })
  default = {
    name = "EC2toS3IAMRole"
  }
}

variable "common_tags" {
  description = "Tags to apply to all IAM users"
  type        = map(string)
  default     = {}
}