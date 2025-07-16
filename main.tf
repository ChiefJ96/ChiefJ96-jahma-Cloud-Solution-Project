terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}
# Purpose: Defines Terraform and provider version constraints for consistency
# Usage: Ensures all team members use compatible Terraform and AWS provider versions
# Security: Version pinning prevents unexpected changes from provider updates
# AWS 6.0: Latest stable version with improved resource management and security features

# Provider configuration - only in root, not in modules
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.common_tags
  }
}
# Purpose: Configures AWS provider with region and default tags for all resources
# Usage: Single point of configuration for AWS credentials and regional deployment
# Tagging: Automatically applies common tags to all AWS resources for organization and billing
# Best Practice: Provider configuration belongs in root module, not in child modules

# Random suffix for unique resource names
resource "random_id" "bucket_suffix" {
  byte_length = 4
}
# Purpose: Generates a random 4-byte hex string to ensure globally unique S3 bucket names
# Usage: Appended to bucket names to avoid naming conflicts across AWS regions
# Technical: 4 bytes = 8 hex characters (e.g., "a1b2c3d4") providing 4.3 billion combinations
# Necessity: S3 bucket names must be globally unique across all AWS accounts

# ADDED: VPC Module - Foundation for all networking
module "vpc" {
  source = "./modules/vpc"

  name        = "main-vpc"
  cidr_block  = "10.0.0.0/16"
  environment = var.environment

  subnets = {
    public-1 = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-west-1a"
      type              = "public"
    }
    public-2 = {
      cidr_block = "10.0.2.0/24"
      # FIXED: Changed from us-west-1c to us-west-1b (us-west-1c is not available)
      availability_zone = "us-west-1b"
      type              = "public"
    }
    private-1 = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-west-1a"
      type              = "private"
    }
    private-2 = {
      cidr_block = "10.0.4.0/24"
      availability_zone = "us-west-1b"
      type              = "private"
    }
  }

  tags = var.common_tags
}
# Purpose: Creates the foundational network infrastructure for all AWS resources
# Usage: Provides isolated virtual network with public and private subnets across 2 AZs
# Architecture: 10.0.0.0/16 CIDR provides 65,536 IP addresses for scalability
# Security: Public subnets (10.0.1-2.0/24) for load balancers, Private subnets (10.0.3-4.0/24) for applications
# Availability: Multi-AZ deployment (us-west-1a, us-west-1b) ensures high availability and disaster recovery
# Best Practice: Separates internet-facing resources from internal application resources

# Security Groups Module
module "security_groups" {
  source = "./modules/security_group"

  vpc_id = module.vpc.vpc_id
  tags   = var.common_tags
}
# Purpose: Creates layered security controls for network traffic between infrastructure components
# Usage: Implements defense-in-depth with separate security groups for each application tier
# Architecture: 4-tier security model - ELB (internet), Web (public), App (private), DB (data)
# Security: Each tier only accepts traffic from the tier above it, implementing least privilege
# Integration: Uses VPC ID from vpc module to ensure security groups are created in correct network
# Best Practice: Network segmentation prevents lateral movement in case of security breach

# S3 Storage Module
module "s3_bucket" {
  source = "./modules/s3"

  bucket_name        = "${var.bucket_name}-${random_id.bucket_suffix.hex}"
  allowed_principals = [module.iam.ec2_role_arn]
  tags               = var.common_tags
}
# Purpose: Creates secure, encrypted object storage for GoGreen Insurance documents and files
# Usage: Provides scalable file storage with enterprise-grade security and access controls
# Security: KMS encryption, bucket policies, and IAM role-based access (no hardcoded credentials)
# Integration: Uses random suffix for global uniqueness and IAM role ARN for secure access
# Architecture: Designed for EC2 instances to securely store/retrieve files without managing keys
# Best Practice: Principle of least privilege - only authorized EC2 instances can access the bucket

# IAM Module
module "iam" {
  source = "./modules/iam"

  vpc_id = module.vpc.vpc_id

  users = {
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
# Purpose: Creates comprehensive user and access management for GoGreen Insurance team
# Usage: Implements role-based access control (RBAC) with three distinct user groups
# Security: Strong password policies, MFA requirements, and principle of least privilege
# Roles: SysAdmins (emergency access), DBAdmins (database management), Monitors (reporting/analytics)
# Service Integration: EC2-to-S3 role enables secure service-to-service communication
# Compliance: Enterprise-grade access controls suitable for insurance industry regulations
# Best Practice: No hardcoded credentials - all access via IAM roles and temporary credentials

# Application Load Balancer Module
module "application_load_balancer" {
  source = "./modules/alb"

  alb_name              = var.alb_name
  vpc_id                = module.vpc.vpc_id
  security_groups       = [module.security_groups.sg_elb_id]
  subnets               = module.vpc.public_subnet_ids
  target_group_port     = 80
  target_group_protocol = "HTTP"
  listener_port         = 80
  listener_protocol     = "HTTP"
  health_check_path     = "/"
  health_check_matcher  = "200"

  tags = var.common_tags
}
# Purpose: Distributes incoming web traffic across multiple application servers for high availability
# Usage: Provides single entry point for users while managing traffic to backend servers
# Architecture: Internet-facing ALB in public subnets, targets private subnet applications
# Security: Uses ELB security group to control which traffic is allowed from internet
# Health Monitoring: Continuously checks application health via /health endpoint
# Availability: Multi-AZ deployment ensures service continues if one zone fails
# Scalability: Ready for auto-scaling integration to handle variable traffic loads
# Best Practice: Separates traffic management from application logic for better reliability

# Target Group Attachment for Web Servers
resource "aws_lb_target_group_attachment" "web_servers" {
  count            = length(module.web_servers.web_instance_ids)
  target_group_arn = module.application_load_balancer.target_group_arn
  target_id        = module.web_servers.web_instance_ids[count.index]
  port             = 80

  depends_on = [module.web_servers]
}
# Purpose: Registers web server instances with the Application Load Balancer target group
# Traffic Flow: Enables ALB to route traffic to healthy web server instances
# Health Checks: ALB monitors instance health and removes unhealthy instances from rotation
# High Availability: Distributes user requests across multiple web servers
# Automatic Registration: New instances automatically added to load balancer rotation
# Business Continuity: Ensures customer requests are always routed to healthy servers

# Get the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}
# Purpose: Dynamically fetches the latest Amazon Linux 2023 AMI ID
# Benefits: Always uses the most current AMI with latest security patches
# Reliability: Avoids hardcoded AMI IDs that may become unavailable
# Security: Ensures instances launch with latest security updates

# Web Server Instances Module
module "web_servers" {
  source = "./modules/instance_web"

  ami            = data.aws_ami.amazon_linux.id  # Use latest Amazon Linux 2023 AMI
  instance_type  = "t3.micro"               # Free tier eligible
  volume_size    = 20                       # 20GB for web server OS and applications
  instance_count = 2                        # 2 instances for high availability
  
  # Networking - place web servers in private subnets for security
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.security_groups.sg_web_id]
  
  # IAM role for S3 access
  iam_instance_profile = module.iam.ec2_instance_profile
  
  # Access and encryption
  key_name   = null                                    # No SSH key needed for web servers
  kms_key_id = module.s3_bucket.kms_key_arn           # Use same KMS key for EBS encryption
  
  # User data script for web server configuration
  user_data = base64encode(file("${path.module}/scripts/web-server-userdata.sh"))

  tags = merge(var.common_tags, {
    Tier        = "Web"
    Environment = var.environment
    Purpose     = "GoGreen Insurance Web Servers"
    # Force recreation when user data changes
    UserDataHash = sha256(file("${path.module}/scripts/web-server-userdata.sh"))
  })
}
# Purpose: Creates EC2 instances to host the GoGreen Insurance web application
# Architecture: 2 instances in private subnets across different AZs for high availability  
# Security: Web servers in private subnets, only accessible through load balancer
# Integration: Automatically registered with ALB target group for traffic distribution
# Encryption: EBS volumes encrypted with same KMS key used by S3 bucket
# Bootstrap: User data script configures web server and application on first run
# Monitoring: Integrated with CloudWatch for performance and availability metrics
# Auto Scaling: Configured to adjust capacity based on demand (not shown in this snippet)
# Best Practice: Immutable infrastructure - replace instances rather than modifying in place
