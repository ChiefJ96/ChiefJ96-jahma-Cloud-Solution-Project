# SECURITY GROUP MODULE OUTPUTS
# This file exposes security group IDs for use by other modules and resources
// security_groups/outputs.tf
output "sg_elb_id" {
  description = "Security group ID for ELB"
  value       = aws_security_group.sg_elb.id
}
# Purpose: Provides the security group ID for the Application Load Balancer
# Usage: Referenced by ALB resources to control internet-facing traffic
# Integration: Used in load balancer configuration and target group settings
# Format: "sg-xxxxxxxxx" - unique identifier within the AWS account
# Security Layer: Controls public internet access to the application
# Public Interface: Gateway security group for all external user traffic

output "sg_web_id" {
  description = "Security group ID for Web Tier"
  value       = aws_security_group.sg_web.id
}
# Purpose: Provides the security group ID for web server instances
# Usage: Attached to EC2 instances hosting the presentation layer
# Traffic Flow: Accepts connections only from the load balancer security group
# Integration: Used by auto scaling groups and launch templates
# Isolation: Ensures web servers cannot be accessed directly from internet
# Architecture: Middle layer in the three-tier security model

output "sg_app_id" {
  description = "Security group ID for App Tier"
  value       = aws_security_group.sg_app.id
}
# Purpose: Provides the security group ID for application server instances
# Usage: Attached to EC2 instances running business logic and APIs
# Access Control: Only accepts connections from web tier security group
# Integration: Used by microservices, containers, and application servers
# API Protection: Secures internal APIs and business logic components
# Service Isolation: Prevents direct access to application layer

output "sg_db_id" {
  description = "Security group ID for Database Tier"
  value       = aws_security_group.sg_db.id
}
# Purpose: Provides the security group ID for database instances
# Usage: Attached to RDS instances, database servers, and data storage
# Maximum Security: Only accepts connections from application tier
# Data Protection: Final security layer protecting sensitive customer data
# Compliance: Critical for meeting insurance industry security requirements
# Database Isolation: Ensures databases cannot be accessed directly from web or internet
# Sensitive Data: Protects personally identifiable information (PII) and financial data