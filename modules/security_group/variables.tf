
# SECURITY GROUP MODULE VARIABLES
# This file defines input variables for the security group module
# Variables control VPC association and resource tagging for security groups

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}
# Purpose: Specifies the Virtual Private Cloud where security groups will be deployed
# Requirement: Security groups must be associated with a specific VPC
# Format: VPC ID in format "vpc-xxxxxxxxx"
# Network Isolation: Ensures security groups operate within the correct network boundary
# Cross-Reference: Must match the VPC ID used by other infrastructure components
# Regional Scope: VPC and security groups must be in the same AWS region
# Architecture: Links security layer to the network infrastructure foundation

variable "tags" {
  description = "Tags to add to all security groups"
  type        = map(string)
  default     = {}
}
# Purpose: Consistent tagging across all security group resources
# Organization: Helps categorize and manage security groups in large environments
# Cost Tracking: Enables billing allocation and cost center reporting
# Compliance: Supports governance policies requiring specific tags
# Examples: {"Environment" = "production", "Project" = "gogreen", "SecurityLevel" = "high"}
# Automation: Used by security scanning tools and compliance checkers
# Operations: Facilitates security group discovery and management
# Best Practice: Apply consistent security tags for audit and monitoring purposes