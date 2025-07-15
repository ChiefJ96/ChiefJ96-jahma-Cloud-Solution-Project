# ADDED: Missing outputs file for CloudWatch module
output "sns_topic_arn" {
  description = "ARN of the SNS topic for alarm notifications"
  value       = aws_sns_topic.alarm_notifications.arn
}

output "low_network_alarm_arn" {
  description = "ARN of the low network bandwidth alarm"
  value       = aws_cloudwatch_metric_alarm.low_network_bandwidth_alarm.arn
}

output "high_network_alarm_arn" {
  description = "ARN of the high network bandwidth alarm"
  value       = aws_cloudwatch_metric_alarm.high_network_bandwidth_alarm.arn
}

output "400_error_alarm_arn" {
  description = "ARN of the 400 error alarm"
  value       = aws_cloudwatch_metric_alarm.http_400_alarm.arn
}

output "high_cpu_alarm_arn" {
  description = "ARN of the high CPU usage alarm"
  value       = aws_cloudwatch_metric_alarm.high_cpu_usage_alarm.arn
}

output "low_cpu_alarm_arn" {
  description = "ARN of the low CPU usage alarm"
  value       = aws_cloudwatch_metric_alarm.low_cpu_usage_alarm.arn
}
