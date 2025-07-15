
output "app_instance_ids" {
  description = "IDs of the app tier instances"
  value       = aws_instance.app[*].id
}

output "app_instance_private_ips" {
  description = "Private IPs of the app tier instances"
  value       = aws_instance.app[*].private_ip
}