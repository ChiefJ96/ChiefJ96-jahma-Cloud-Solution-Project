
# ADDED: VPC outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# ADDED: Security Group outputs
output "security_group_ids" {
  description = "Security group IDs"
  value = {
    elb = module.security_groups.sg_elb_id
    web = module.security_groups.sg_web_id
    app = module.security_groups.sg_app_id
    db  = module.security_groups.sg_db_id
  }
}

# ADDED: ALB outputs
output "alb_dns_name" {
  description = "ALB DNS name for accessing the application"
  value       = module.application_load_balancer.alb_dns_name
}

output "alb_arn" {
  description = "ALB ARN"
  value       = module.application_load_balancer.alb_arn
}

# ADDED: S3 outputs
output "s3_bucket_id" {
  description = "S3 bucket ID"
  value       = module.s3_bucket.bucket_id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = module.s3_bucket.bucket_arn
}

# IAM outputs
output "sysadmin_users" {
  description = "List of SysAdmin IAM usernames"
  value       = module.iam.sysadmin_users
}

output "dbadmin_users" {
  description = "List of DBAdmin IAM usernames"
  value       = module.iam.dbadmin_users
}

output "monitor_users" {
  description = "List of Monitor IAM usernames"
  value       = module.iam.monitor_users
}

output "ec2_role_arn" {
  description = "ARN of EC2 IAM Role with S3 full access"
  value       = module.iam.ec2_role_arn
}

output "ec2_instance_profile" {
  description = "EC2 instance profile name"
  value       = module.iam.ec2_instance_profile
}