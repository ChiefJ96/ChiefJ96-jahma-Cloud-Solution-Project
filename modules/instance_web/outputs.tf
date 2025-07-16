
# WEB SERVER MODULE OUTPUTS
# This file exposes important web server information for integration with other modules

output "web_instance_ids" {
  description = "IDs of the web tier instances"
  value       = aws_instance.web[*].id
}
# Purpose: Provides instance IDs for integration with load balancers and monitoring
# Usage: Used by ALB target group attachments and CloudWatch alarms
# Format: List of instance IDs like ["i-1234567890abcdef0", "i-abcdef1234567890"]

output "web_instance_public_ips" {
  description = "Public IPs of the web tier instances"
  value       = aws_instance.web[*].public_ip
}
# Purpose: Provides public IP addresses if instances are in public subnets
# Usage: For direct SSH access during development (not recommended for production)
# Security: Should be empty list for production web servers in private subnets
# Best Practice: Web servers should only be accessible through load balancer

output "web_instance_private_ips" {
  description = "Private IP addresses of the web tier instances"
  value       = aws_instance.web[*].private_ip
}
# Purpose: Provides private IP addresses for internal network communication
# Usage: Used for monitoring, logging, and internal service discovery
# Security: Private IPs only accessible within VPC for enhanced security
# Example: ["10.0.3.100", "10.0.4.100"]

output "web_instance_arns" {
  description = "ARNs of the web tier instances"
  value       = aws_instance.web[*].arn
}
# Purpose: Provides full ARNs for IAM policies and resource-based permissions
# Usage: Required for IAM policies that grant permissions to specific instances
# Format: "arn:aws:ec2:region:account:instance/instance-id"
# Integration: Used in backup policies, monitoring roles, and compliance reporting