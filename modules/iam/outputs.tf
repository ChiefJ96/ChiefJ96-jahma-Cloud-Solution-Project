
output "sysadmin_users" {
  description = "List of SysAdmin IAM usernames"
  value       = [for user in aws_iam_user.sysadmin_users : user.name]
}

output "dbadmin_users" {
  description = "List of DBAdmin IAM usernames"
  value       = [for user in aws_iam_user.dbadmin_users : user.name]
}

output "monitor_users" {
  description = "List of Monitor IAM usernames"
  value       = [for user in aws_iam_user.monitor_users : user.name]
}

output "ec2_role_arn" {
  description = "ARN of EC2 IAM Role with S3 full access"
  value       = aws_iam_role.ec2s3_role.arn
}

output "ec2_instance_profile" {
  description = "EC2 instance profile name"
  value       = aws_iam_instance_profile.ec2s3_instance_profile.name
}