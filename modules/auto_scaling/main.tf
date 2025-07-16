# AUTO SCALING MODULE - MAIN CONFIGURATION
# This module provides auto scaling capabilities for the GoGreen Insurance application
# It creates launch templates, auto scaling groups, scaling policies, and CloudWatch alarms
# Purpose: Ensures application availability and automatically adjusts capacity based on demand

# FIXED: Removed provider configuration from module - should be in root configuration
# Provider blocks should not be in modules, they belong in the root configuration

resource "aws_launch_template" "main" {
  name_prefix            = var.launch_template.prefix
  image_id               = var.launch_template.ami
  instance_type          = var.launch_template.instance_class
  description            = var.launch_template.description
  tags                   = var.tags
  key_name               = var.launch_template.key_name
  user_data              = var.launch_template.user_data
  vpc_security_group_ids = [var.launch_template.security_group_id]
  monitoring {
    enabled = var.launch_template.detailed_monitoring
  }
}
# Purpose: Defines the template for launching new EC2 instances
# Functionality: Specifies AMI, instance type, security groups, and user data
# User Data: Bootstrap scripts that configure instances during launch
# Security: Attaches appropriate security groups for network access control
# Monitoring: Optional detailed monitoring for enhanced CloudWatch metrics
# Scaling: Template ensures all auto-scaled instances have consistent configuration

resource "aws_autoscaling_group" "main" {
  vpc_zone_identifier = var.scaling_group.subnet_ids
  desired_capacity    = var.scaling_group.desired_capacity
  max_size            = var.scaling_group.max_size
  min_size            = var.scaling_group.min_size
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  # FIXED: Updated to use renamed variable
  target_group_arns = var.attach_to_lb ? [var.target_group_arn] : []
}
# Purpose: Manages the automatic scaling of EC2 instances based on demand
# High Availability: Distributes instances across multiple availability zones
# Capacity Management: Maintains desired number of healthy instances
# Auto Recovery: Automatically replaces unhealthy instances
# Load Balancer Integration: Registers instances with target groups
# Tag Propagation: Ensures all launched instances inherit proper tags
# Cost Optimization: Scales down during low demand periods

resource "aws_autoscaling_policy" "policies" {
  for_each               = var.scaling_policies
  name                   = each.value.name
  scaling_adjustment     = each.value.scaling_adjustment
  adjustment_type        = each.value.adjustment_type
  cooldown               = each.value.cooldown
  autoscaling_group_name = aws_autoscaling_group.main.name
  policy_type            = "SimpleScaling"
}
# Purpose: Defines scaling actions triggered by CloudWatch alarms
# Simple Scaling: Uses fixed scaling adjustments (add/remove X instances)
# Cooldown Period: Prevents rapid scaling oscillations and allows metrics to stabilize
# Adjustment Types: Supports ChangeInCapacity, ExactCapacity, PercentChangeInCapacity
# Integration: Works with CloudWatch alarms to trigger automatic scaling
# Business Impact: Ensures application performance during traffic spikes

# FIXED: Updated auto scaling attachment to use correct variable name
resource "aws_autoscaling_attachment" "my_asg_attachment" {
  count                  = var.attach_to_lb ? 1 : 0
  autoscaling_group_name = aws_autoscaling_group.main.name
  lb_target_group_arn    = var.target_group_arn
}
# Purpose: Connects the auto scaling group to the application load balancer
# Traffic Distribution: Newly launched instances automatically receive traffic
# Health Checks: Load balancer health checks determine instance health
# Conditional Creation: Only created when load balancer integration is enabled
# High Availability: Ensures scaled instances participate in load balancing
# Seamless Scaling: Users experience no disruption during scaling events

resource "aws_cloudwatch_metric_alarm" "reduce_ec2_alarm" {
  for_each                  = var.cloudwatch_alarms
  alarm_name                = each.value.name
  comparison_operator       = each.value.comparison_operator
  evaluation_periods        = each.value.evaluation_periods
  metric_name               = each.value.metric_name
  namespace                 = "AWS/EC2"
  period                    = each.value.period
  statistic                 = each.value.statistic
  threshold                 = each.value.threshold
  alarm_description         = each.value.alarm_description
  insufficient_data_actions = []

  alarm_actions = ["${aws_autoscaling_policy.policies[each.value.policy_to_use].arn}"]
}
# Purpose: Monitors EC2 metrics and triggers scaling actions automatically
# Metric Sources: CPU utilization, network traffic, custom application metrics
# Evaluation Logic: Monitors metrics over specified periods before triggering
# Alarm Actions: Executes scaling policies when thresholds are breached
# Business Value: Maintains application performance during varying load conditions
# Cost Control: Scales down during low usage periods to reduce costs
# Proactive Scaling: Anticipates capacity needs based on metric trends