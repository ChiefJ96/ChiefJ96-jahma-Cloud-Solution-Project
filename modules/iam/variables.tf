variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}
# Purpose: Required VPC ID for creating IAM resources that need to be associated with a specific VPC
# Usage: Passed from the root module to ensure IAM resources are created in the correct network context

variable "minimum_password_length" {
  description = "Minimum length for IAM passwords"
  type        = number
  default     = 8
}
# Purpose: Enforces minimum password length for all IAM users to improve security
# Usage: Part of AWS IAM password policy - prevents users from creating weak, short passwords
# Security: 8 characters is a reasonable minimum that balances security with usability

variable "require_uppercase_characters" {
  description = "Require uppercase letters in IAM passwords"
  type        = bool
  default     = true
}
# Purpose: Forces users to include uppercase letters in their passwords
# Usage: Part of password complexity requirements - makes passwords harder to crack
# Security: Increases password entropy by requiring mixed case characters

variable "require_lowercase_characters" {
  description = "Require lowercase letters in IAM passwords"
  type        = bool
  default     = true
}
# Purpose: Forces users to include lowercase letters in their passwords
# Usage: Works with uppercase requirement to ensure mixed case complexity
# Security: Standard password policy requirement for professional environments

variable "require_symbols" {
  description = "Require special characters in IAM passwords"
  type        = bool
  default     = true
}
# Purpose: Forces users to include special characters (!@#$%^&*) in passwords
# Usage: Significantly increases password complexity and security strength
# Security: Special characters make brute force attacks much more difficult

variable "require_numbers" {
  description = "Require numbers in IAM passwords"
  type        = bool
  default     = true
}
# Purpose: Forces users to include numeric characters (0-9) in their passwords
# Usage: Completes the character set requirements for strong passwords
# Security: Numbers add another layer of complexity to password combinations

variable "max_password_age" {
  description = "Maximum password age in days before reset"
  type        = number
  default     = 90
}
# Purpose: Forces users to change passwords regularly to maintain security
# Usage: Prevents indefinite use of potentially compromised passwords
# Security: 90 days is industry standard - frequent enough for security, not too burdensome for users

variable "password_reuse_prevention" {
  description = "Number of previous passwords that cannot be reused"
  type        = number
  default     = 3
}
# Purpose: Prevents users from cycling back to recently used passwords
# Usage: Maintains password history to ensure users create genuinely new passwords
# Security: Prevents users from alternating between 2-3 familiar passwords

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
# Purpose: Defines IAM groups for role-based access control (RBAC)
# Usage: Creates logical groupings of users with similar permission needs
# Security: Implements principle of least privilege - users get only permissions needed for their role
# Groups: SysAdmin (full access), DBAdmin (database management), Monitor (read-only reporting)

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
# Purpose: Defines specific IAM users organized by their functional roles
# Usage: Creates individual user accounts with appropriate group memberships
# Structure: Map format allows easy addition/removal of users per group
# Security: Each user gets unique credentials but inherits group permissions
# Design: 2 sysadmins (emergencies), 2 dbadmins (database ops), 4 monitors (reporting team)

variable "ec2_role" {
  description = "EC2 IAM role configuration"
  type = object({
    name = string
  })
  default = {
    name = "EC2toS3IAMRole"
  }
}
# Purpose: Defines IAM role for EC2 instances to access S3 without hardcoded credentials
# Usage: Allows EC2 instances to securely access S3 buckets using temporary credentials
# Security: Eliminates need to store AWS access keys on EC2 instances
# Best Practice: Service roles provide secure, automatic credential rotation

variable "common_tags" {
  description = "Tags to apply to all IAM users"
  type        = map(string)
  default     = {}
}
# Purpose: Provides consistent tagging across all IAM resources for organization and billing
# Usage: Applied to all IAM users and roles for resource management and cost tracking
# Benefits: Enables filtering, grouping, and cost allocation by department, project, or environment
# Flexibility: Empty default allows customization per deployment without breaking the module