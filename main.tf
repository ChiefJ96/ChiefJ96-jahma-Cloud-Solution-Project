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

# Provider configuration - only in root, not in modules
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.common_tags
  }
}

# Random suffix for unique resource names
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

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
      # FIXED: Changed from us-west-1c to us-west-1b (us-west-1c is not available)
      availability_zone = "us-west-1b"
      type              = "private"
    }
  }

  tags = var.common_tags
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security_group"

  vpc_id = module.vpc.vpc_id
  tags   = var.common_tags
}

# S3 Storage Module
module "s3_bucket" {
  source = "./modules/s3"

  bucket_name        = "${var.bucket_name}-${random_id.bucket_suffix.hex}"
  allowed_principals = [module.iam.ec2_role_arn]
  tags               = var.common_tags
}

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
  health_check_path     = "/health"
  health_check_matcher  = "200"

  tags = var.common_tags
}
