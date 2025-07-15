
# FIXED: Added Terraform and provider version constraints
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # ADDED: Random provider for unique naming
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.common_tags
  }
}

# ADDED: VPC Module - Foundation for all networking
module "vpc" {
  source = "./modules/vpc"

  name        = "main-vpc"
  cidr_block  = "10.0.0.0/16"
  environment = "production"

  subnets = {
    public-1 = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-west-1a"
      type              = "public"
    }
    public-2 = {
      cidr_block        = "10.0.2.0/24"
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
      cidr_block        = "10.0.4.0/24"
      # FIXED: Changed from us-west-1c to us-west-1b (us-west-1c is not available)
      availability_zone = "us-west-1b"
      type              = "private"
    }
  }

  tags = var.common_tags
}

# ADDED: Security Groups Module
module "security_groups" {
  source = "./modules/security_group"

  vpc_id = module.vpc.vpc_id
  tags   = var.common_tags
}

# ADDED: S3 Module for storage
module "s3_bucket" {
  source = "./modules/s3"

  bucket_name = "gogreen-insurance-${random_id.bucket_suffix.hex}"
  allowed_principals = [
    module.iam.ec2_role_arn
  ]
  tags = var.common_tags
}

# ADDED: ALB Module for load balancing
module "application_load_balancer" {
  source = "./modules/alb"

  alb_name        = "gogreen-alb"
  vpc_id          = module.vpc.vpc_id
  security_groups = [module.security_groups.sg_elb_id]
  # FIXED: Use proper VPC output format
  subnets = module.vpc.public_subnet_ids

  target_group_port     = 80
  target_group_protocol = "HTTP"
  listener_port         = 80
  listener_protocol     = "HTTP"

  health_check_path    = "/health"
  health_check_matcher = "200"

  tags = var.common_tags
}

module "iam" {
  source = "./modules/iam"

  minimum_password_length      = var.minimum_password_length
  require_uppercase_characters = var.require_uppercase_characters
  require_lowercase_characters = var.require_lowercase_characters
  require_symbols              = var.require_symbols
  require_numbers              = var.require_numbers
  max_password_age             = var.max_password_age
  password_reuse_prevention    = var.password_reuse_prevention

  groups = var.groups
  users  = var.users

  ec2_role = var.ec2_role

  # FIXED: Use VPC ID from VPC module instead of variable
  vpc_id = module.vpc.vpc_id

  common_tags = var.common_tags
}

# ADDED: Random ID for unique resource naming
resource "random_id" "bucket_suffix" {
  byte_length = 4
}
