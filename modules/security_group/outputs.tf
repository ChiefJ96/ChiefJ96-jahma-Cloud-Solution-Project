// security_groups/outputs.tf
output "sg_elb_id" {
  description = "Security group ID for ELB"
  value       = aws_security_group.sg_elb.id
}

output "sg_web_id" {
  description = "Security group ID for Web Tier"
  value       = aws_security_group.sg_web.id
}

output "sg_app_id" {
  description = "Security group ID for App Tier"
  value       = aws_security_group.sg_app.id
}

output "sg_db_id" {
  description = "Security group ID for Database Tier"
  value       = aws_security_group.sg_db.id
}