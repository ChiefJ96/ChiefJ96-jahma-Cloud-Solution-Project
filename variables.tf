# ROOT CONFIGURATION VARIABLES
# This file defines all input variables for the GoGreen Insurance infrastructure
# Variables control regional deployment, security policies, and application configuration
# Purpose: Centralized configuration management for the entire cloud infrastructure

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-1"
}
# Purpose: Defines the AWS region where all infrastructure will be deployed
# Impact: Affects latency, data sovereignty, compliance, and service availability
# Default: us-west-1 (California) chosen for west coast business operations
# Considerations: Choose region based on user location, data residency laws
# Cost Impact: Pricing varies by region for compute and storage resources
# Integration: All modules and resources must be deployed in this region

# REMOVED: vpc_id variable since we're creating VPC in main.tf
# variable "vpc_id" is no longer needed

# ============================================================================
# IAM PASSWORD POLICY CONFIGURATION
# These variables define security requirements for IAM user passwords
# Purpose: Enforces strong password policies for insurance industry compliance
# ============================================================================

variable "minimum_password_length" {
  description = "Minimum length for IAM passwords"
  type        = number
  default     = 8
}
# Purpose: Sets minimum character count for IAM user passwords
# Security: Longer passwords provide better protection against brute force attacks
# Compliance: Meets insurance industry security standards and regulatory requirements
# Default: 8 characters (minimum recommended by NIST)
# Business Impact: Balances security with user experience
# Best Practice: Consider 12+ characters for high-privilege accounts

variable "require_uppercase_characters" {
  description = "Require uppercase letters in IAM passwords"
  type        = bool
  default     = true
}
# Purpose: Forces inclusion of uppercase letters in passwords
# Security: Increases password complexity and reduces dictionary attack success
# Compliance: Required by many security frameworks including PCI DSS
# User Impact: Users must include at least one capital letter
# Password Examples: Must contain A-Z characters

variable "require_lowercase_characters" {
  description = "Require lowercase letters in IAM passwords"
  type        = bool
  default     = true
}
# Purpose: Forces inclusion of lowercase letters in passwords
# Security: Combined with uppercase requirement increases character space
# Balance: Ensures passwords contain mixed case for complexity
# User Experience: Standard requirement for most secure systems
# Password Examples: Must contain a-z characters

variable "require_symbols" {
  description = "Require special characters in IAM passwords"
  type        = bool
  default     = true
}
# Purpose: Forces inclusion of special characters in passwords
# Security: Special characters significantly increase password strength
# Complexity: Makes passwords harder to guess and crack
# Examples: Requires characters like !@#$%^&*()
# User Training: May require user education on acceptable symbols

variable "require_numbers" {
  description = "Require numbers in IAM passwords"
  type        = bool
  default     = true
}
# Purpose: Forces inclusion of numeric characters in passwords
# Security: Numbers add another character class for complexity
# Standard Practice: Most security policies require numeric inclusion
# Password Examples: Must contain 0-9 characters
# Complexity: Combined with other requirements creates strong passwords

variable "max_password_age" {
  description = "Maximum password age in days before reset"
  type        = number
  default     = 90
}
# Purpose: Forces regular password rotation for enhanced security
# Security: Limits exposure window if passwords are compromised
# Compliance: Required by many insurance and financial regulations
# Operational Impact: Users must change passwords quarterly
# Balance: 90 days balances security with user convenience
# Business Continuity: Prevents service disruption from expired passwords

variable "password_reuse_prevention" {
  description = "Number of previous passwords that cannot be reused"
  type        = number
  default     = 3
}
# Purpose: Prevents users from cycling through a few familiar passwords
# Security: Ensures password changes are meaningful and not just cosmetic
# Memory Requirement: System remembers last 3 passwords per user
# User Impact: Forces creative password creation instead of minor variations
# Compliance: Standard requirement in security frameworks

# ============================================================================
# IAM USER AND GROUP CONFIGURATION
# These variables define organizational structure for user access management
# Purpose: Implements role-based access control for the insurance organization
# ============================================================================

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
# Purpose: Defines IAM groups for role-based access control in GoGreen Insurance
# SysAdmin Group: Full system administrators with broad infrastructure access
# DBAdmin Group: Database administrators with data management permissions
# Monitor Group: Read-only access for monitoring and compliance staff
# Business Value: Implements principle of least privilege access
# Scaling: Easy to add new groups as organization grows
# Compliance: Supports audit requirements with clear role separation

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
# Purpose: Defines individual IAM users and their group assignments
# Map Structure: username = "actual_username" for flexible naming
# SysAdmin Users: 2 users for critical system administration
# DBA Users: 2 users for database management and maintenance
# Monitor Users: 4 users for compliance, auditing, and monitoring
# Business Continuity: Multiple users per role prevent single points of failure
# Security: Each user gets individual credentials and audit trail
# Scalability: Easy to add/remove users without code changes

variable "ec2_role" {
  description = "EC2 IAM role configuration"
  type = object({
    name = string
  })
  default = {
    name = "EC2toS3IAMRole"
  }
}
# Purpose: Defines IAM role for EC2 instances to access AWS services
# Service Role: Allows EC2 instances to access S3 buckets securely
# No Credentials: Eliminates need for hardcoded access keys in applications
# Security: Temporary credentials automatically rotated by AWS
# Integration: Used by web servers and application servers
# Best Practice: Preferred method for AWS service-to-service authentication

# ============================================================================
# GLOBAL RESOURCE CONFIGURATION
# These variables define naming, tagging, and environment settings
# Purpose: Ensures consistent resource management across the infrastructure
# ============================================================================

variable "common_tags" {
  description = "Tags to apply to all IAM users and resources"
  type        = map(string)
  default = {
    Project   = "GoGreenInsurance"
    ManagedBy = "Terraform"
  }
}
# Purpose: Consistent tagging strategy across all AWS resources
# Project Tag: Identifies resources belonging to GoGreen Insurance
# ManagedBy Tag: Indicates resources are managed by Infrastructure as Code
# Cost Allocation: Enables detailed billing and cost center reporting
# Resource Management: Facilitates bulk operations and cleanup
# Compliance: Supports governance policies and audit requirements
# Operations: Helps identify resource ownership and responsibility

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}
# Purpose: Identifies the deployment environment for resource naming and policies
# Default: "production" for live customer-facing environment
# Usage: Appended to resource names to distinguish environments
# Other Values: "development", "staging", "test" for different deployments
# Policies: Different security and backup policies per environment
# Cost Management: Enables environment-based cost tracking and optimization

variable "bucket_name" {
  description = "Base name for S3 bucket"
  type        = string
  default     = "gogreen-insurance"
}
# Purpose: Base name for S3 storage buckets
# Global Uniqueness: S3 bucket names must be globally unique
# Naming Convention: Company name with clear purpose identification
# Environment Suffix: Environment name will be appended automatically
# Examples: "gogreen-insurance-production", "gogreen-insurance-dev"
# Use Cases: Application data, document storage, backup repositories

variable "alb_name" {
  description = "Name for the Application Load Balancer"
  type        = string
  default     = "gogreen-alb"
}
# Purpose: Name for the Application Load Balancer serving customer traffic
# DNS Integration: Used as part of the auto-generated DNS name
# Resource Identification: Makes load balancer easy to identify in AWS console
# Monitoring: Used in CloudWatch metrics and alarms for clarity
# Operational: Simplifies troubleshooting and management tasks
# Customer Impact: Part of the URL customers use to access services