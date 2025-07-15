
output "web_instance_ids" {
  description = "IDs of the web tier instances"
  value       = aws_instance.web[*].id
}

output "web_instance_public_ips" {
  description = "Public IPs of the web tier instances"
  value       = aws_instance.web[*].public_ip
}