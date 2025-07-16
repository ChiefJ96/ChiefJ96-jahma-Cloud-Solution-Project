
# AUTO SCALING MODULE VARIABLES
# This file defines all input variables for the auto scaling module
# Variables control launch templates, scaling behavior, and monitoring configuration

variable "region" {
  type = string
}
# Purpose: Specifies the AWS region for auto scaling group deployment
# Usage: Determines where EC2 instances will be launched
# Example: "us-west-1", "us-east-1", "eu-west-1"
# Impact: Affects latency, data sovereignty, and service availability
# Integration: Must match the region of VPC subnets and other resources

variable "launch_template" {
  type = object({
    ami                 = string
    prefix              = string
    instance_class      = string
    description         = optional(string)
    detailed_monitoring = optional(bool, false)
    key_name            = optional(string)
    security_group_id   = optional(string)
    user_data           = optional(string)
  })
}
# Purpose: Defines the template configuration for launching new EC2 instances
# AMI: Amazon Machine Image ID containing the application and operating system
# Prefix: Name prefix for the launch template (e.g., "gogreen-web-server")
# Instance Class: EC2 instance type (t3.micro, m5.large, etc.)
# Description: Human-readable description of the launch template purpose
# Detailed Monitoring: Enables 1-minute CloudWatch metrics (additional cost)
# Key Name: SSH key pair for instance access (optional for web servers)
# Security Group ID: Firewall rules controlling network access
# User Data: Bootstrap script executed when instances launch
# Best Practice: Use immutable AMIs with application pre-installed

variable "scaling_group" {
  type = object({
    subnet_ids       = optional(list(string))
    desired_capacity = number
    max_size         = number
    min_size         = number
  })
}
# Purpose: Configures the auto scaling group capacity and network placement
# Subnet IDs: List of VPC subnets where instances can be launched
# Desired Capacity: Target number of running instances under normal conditions
# Max Size: Maximum number of instances during scale-out events
# Min Size: Minimum number of instances for high availability
# High Availability: Distribute instances across multiple availability zones
# Cost Optimization: Set min_size to 0 for dev environments to reduce costs
# Business Continuity: Ensure min_size covers baseline capacity requirements

variable "tags" {
  type    = map(string)
  default = {}
}
# Purpose: Resource tags applied to all auto scaling resources and instances
# Usage: Supports cost allocation, resource organization, and compliance
# Propagation: Tags are automatically applied to launched EC2 instances
# Examples: {"Environment" = "production", "Project" = "gogreen", "Owner" = "dev-team"}
# Billing: Enables cost tracking and chargeback by department or project
# Compliance: Required tags for governance and security policies

variable "scaling_policies" {
  type = map(object({
    name               = string
    scaling_adjustment = number
    adjustment_type    = string
    cooldown           = number
  }))
}
# Purpose: Defines how the auto scaling group responds to metric alarms
# Name: Descriptive name for the scaling policy (e.g., "scale-out-cpu")
# Scaling Adjustment: Number of instances to add/remove or percentage change
# Adjustment Type: "ChangeInCapacity", "ExactCapacity", or "PercentChangeInCapacity"
# Cooldown: Time (seconds) to wait before allowing another scaling action
# Scale-Out Policy: Typically adds 1-2 instances when demand increases
# Scale-In Policy: Typically removes 1 instance when demand decreases
# Business Impact: Balances application performance with infrastructure costs

variable "attach_to_lb" {
  type    = bool
  default = false
}
# Purpose: Controls whether auto scaling group integrates with load balancer
# Usage: Set to true for web-facing applications requiring load distribution
# Effect: Newly launched instances automatically register with target group
# Health Checks: Load balancer health checks determine instance availability
# Traffic Flow: Only healthy instances receive user traffic
# Default: false to allow auto scaling without load balancer dependency

# FIXED: Renamed variable to be more descriptive - this should be target group ARN, not load balancer ARN
variable "target_group_arn" {
  type        = string
  default     = ""
  description = "ARN of the target group to attach the auto scaling group to"
}
# Purpose: Specifies the load balancer target group for instance registration
# Format: "arn:aws:elasticloadbalancing:region:account:targetgroup/name/id"
# Integration: Links auto scaling group with application load balancer
# Traffic Distribution: Ensures scaled instances participate in load balancing
# High Availability: Provides seamless scaling without service interruption
# Requirement: Must be provided when attach_to_lb is true

variable "cloudwatch_alarms" {
  type = map(object({
    name                      = string
    comparison_operator       = string
    evaluation_periods        = number
    metric_name               = string
    period                    = number
    statistic                 = string
    threshold                 = number
    alarm_description         = string
    insufficient_data_actions = optional(list(string))
    policy_to_use             = string
  }))
}
# Purpose: Defines CloudWatch alarms that trigger auto scaling actions
# Name: Unique alarm name for identification and monitoring
# Comparison Operator: "GreaterThanThreshold", "LessThanThreshold", etc.
# Evaluation Periods: Number of consecutive periods threshold must be breached
# Metric Name: AWS metric to monitor (CPUUtilization, NetworkIn, etc.)
# Period: Time interval (seconds) for metric aggregation (300 = 5 minutes)
# Statistic: Aggregation method (Average, Maximum, Sum, etc.)
# Threshold: Numeric value that triggers the alarm when breached
# Alarm Description: Human-readable explanation of alarm purpose
# Policy to Use: References scaling policy to execute when alarm triggers
# Common Metrics: CPU >70% (scale out), CPU <30% (scale in)
# Business Value: Automatically maintains application performance and cost efficiency