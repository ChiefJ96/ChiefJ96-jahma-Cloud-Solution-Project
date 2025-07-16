
# WEB SERVER INSTANCES MODULE
# This module creates EC2 instances for the web tier of cloud applications
# Purpose: Hosts the presentation layer that serves web content to users

resource "aws_instance" "web" {
  count                  = var.instance_count
  ami                   = var.ami
  instance_type         = var.instance_type
  key_name              = var.key_name
  subnet_id             = length(var.subnet_ids) > 0 ? var.subnet_ids[count.index % length(var.subnet_ids)] : null
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile  = var.iam_instance_profile
  user_data_base64     = var.user_data != "" ? var.user_data : null

  tags = merge(var.tags, {
    Name = "web-server-${count.index + 1}"
    Tier = "Web"
  })

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    encrypted             = true
    kms_key_id            = var.kms_key_id
    delete_on_termination = true
  }

  # Enable detailed monitoring for better CloudWatch metrics
  monitoring = true

  # Ensure instances are distributed across availability zones
  availability_zone = length(var.subnet_ids) > 0 ? null : data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
}
# Purpose: Creates web server instances with proper networking and security configuration
# High Availability: Distributes instances across multiple subnets/AZs automatically
# Security: Attaches security groups and places instances in specified subnets
# Monitoring: Enables detailed CloudWatch monitoring for performance tracking
# Encryption: EBS volumes encrypted with customer-managed KMS key
# Bootstrap: User data script configures web server software and application
# Naming: Clear instance names for easier identification and management

# Get available AZs for instance placement when subnet_ids not provided
data "aws_availability_zones" "available" {
  state = "available"
}
# Purpose: Provides list of available availability zones for instance distribution
# Usage: Fallback when subnet_ids are not specified
# High Availability: Ensures instances are spread across different AZs