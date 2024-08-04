output "arn" {
  description = "ARN of the Step Function"
  value       = aws_sfn_state_machine.this.arn
}

output "name" {
  description = "Name of the Step Function"
  value       = aws_sfn_state_machine.this.name
}