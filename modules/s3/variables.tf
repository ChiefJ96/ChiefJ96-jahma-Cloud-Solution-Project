
# S3 MODULE VARIABLES
# This file defines input variables for the S3 storage module
# Variables control bucket configuration, access permissions, and resource tagging

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}
# Purpose: Specifies the globally unique name for the S3 bucket
# Requirements: Must be globally unique across all AWS accounts
# Naming Convention: Use descriptive names with environment prefix
# Examples: "gogreen-insurance-prod-data", "gogreen-dev-uploads"
# Restrictions: 3-63 characters, lowercase letters, numbers, hyphens only
# Business Impact: Name appears in URLs and affects bucket organization
# Best Practice: Include environment and purpose in the name

variable "allowed_principals" {
  description = "List of AWS principals allowed to access the bucket"
  type        = list(string)
  default     = ["*"]
}
# Purpose: Defines which AWS identities can access the S3 bucket
# Security: Controls access at the resource level through bucket policy
# Principal Types: IAM users, roles, AWS accounts, or services
# Format: ARN format - "arn:aws:iam::account:user/username"
# Default: "*" allows public access (should be restricted in production)
# Production Use: Replace with specific IAM roles and service accounts
# Examples: ["arn:aws:iam::123456789012:role/WebServerRole"]
# Security Best Practice: Never use "*" for sensitive data buckets

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
# Purpose: Resource tags for organization, billing, and compliance
# Cost Management: Enables detailed cost allocation and chargeback
# Organization: Groups related resources for easier management
# Compliance: Supports governance policies and audit requirements
# Examples: {"Environment" = "production", "Project" = "gogreen", "DataClass" = "sensitive"}
# Automation: Used by backup policies and lifecycle management
# Billing: Critical for tracking storage costs by department or project
# Best Practice: Establish consistent tagging strategy across all environments