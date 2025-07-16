variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}
# Purpose: Defines the unique name for the ALB resource in AWS
# Usage: Used for AWS resource naming and identification in the console
# Requirements: Must be unique within the AWS region and follow AWS naming conventions
# Integration: Referenced in target group and listener naming for consistency

variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
}
# Purpose: Specifies which Virtual Private Cloud the ALB will be deployed in
# Usage: Ensures ALB is created in the correct network environment
# Security: ALB must be in same VPC as target instances for communication
# Integration: Links ALB to the broader network infrastructure and security context

variable "subnets" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}
# Purpose: Defines which subnets the ALB will be deployed across for high availability
# Usage: ALB nodes are distributed across multiple subnets in different AZs
# Requirements: Must be public subnets if ALB is internet-facing
# Best Practice: Use subnets in multiple AZs for fault tolerance and load distribution

variable "security_groups" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}
# Purpose: Controls network traffic allowed to and from the ALB
# Usage: Defines which ports and protocols the ALB can accept
# Security: Acts as virtual firewall protecting the load balancer
# Integration: Usually includes ELB security group allowing HTTP/HTTPS from internet

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}
# Purpose: Defines which port the ALB will use to communicate with backend servers
# Usage: ALB forwards traffic to this port on the target instances
# Default: Port 80 for standard HTTP web traffic
# Flexibility: Can be changed for applications running on different ports

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}
# Purpose: Specifies the protocol for communication between ALB and backend servers
# Usage: Determines how ALB formats requests when forwarding to targets
# Default: HTTP for web applications (can be HTTPS for encrypted backend communication)
# Health Checks: Must match the protocol the backend servers are configured to accept

variable "listener_port" {
  description = "Port for the listener"
  type        = number
  default     = 80
}
# Purpose: Defines which port the ALB listens on for incoming traffic from the internet
# Usage: Users connect to this port when accessing the application
# Default: Port 80 for standard HTTP web traffic (port 443 for HTTPS)
# Public Interface: This is the port users see in their browser URLs

variable "listener_protocol" {
  description = "Protocol for the listener"
  type        = string
  default     = "HTTP"
}
# Purpose: Specifies the protocol for incoming traffic from users
# Usage: Determines how ALB processes incoming requests from the internet
# Default: HTTP for standard web traffic (can be HTTPS with SSL certificates)
# Security: HTTPS provides encryption for sensitive data transmission

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/health"
}
# Purpose: Defines the URL path the ALB uses to check if backend servers are healthy
# Usage: ALB periodically sends HTTP requests to this path on each target server
# Default: "/health" is a common endpoint for application health status
# Requirements: Backend applications must implement this endpoint to return health status
# Monitoring: Unhealthy servers are automatically removed from traffic rotation

variable "health_check_matcher" {
  description = "Health check response matcher"
  type        = string
  default     = "200"
}
# Purpose: Defines what HTTP response code indicates a healthy server
# Usage: ALB considers a server healthy only if it returns this status code
# Default: "200" means HTTP OK - server is functioning normally
# Flexibility: Can be configured for multiple codes like "200,202" if needed
# Reliability: Ensures only properly functioning servers receive user traffic

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
# Purpose: Provides metadata tags for AWS resource organization and billing
# Usage: Applied to all ALB-related resources for consistent labeling
# Benefits: Enables cost tracking, resource filtering, and organizational compliance
# Flexibility: Empty default allows customization per deployment environment
# Best Practice: Consistent tagging across all infrastructure components
