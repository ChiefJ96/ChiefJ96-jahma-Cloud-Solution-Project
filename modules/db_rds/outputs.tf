// modules/db_rds/outputs.tf
output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.db.id
}

output "db_endpoint" {
  description = "RDS endpoint address"
  value       = aws_db_instance.db.endpoint
}

output "db_port" {
  description = "RDS port"
  value       = aws_db_instance.db.port
}