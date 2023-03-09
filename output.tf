# IAM 
output "iam_role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.aws_backup_role.arn
}

# KMS
output "kms_key_id" {
  description = "ID of the KMS key"
  value       = aws_kms_key.aws_backup_kms_key.key_id
}

# AWS Backup
output "backup_vault_arn" {
  description = "ARN of the Backup Vault"
  value       = aws_backup_vault.this.arn
}

output "backup_plan_id" {
  description = "ID of the backup plan"
  value       = aws_backup_plan.this.id
}

output "backup_selection_plan_id" {
  description = "ID of the backup selection plan"
  value       = [for selection in aws_backup_selection.this : selection.id]
}

# SNS
output "backup_sns_topic_arn" {
  description = "ARN of the SNS topic used for AWS backup notifications"
  value       = aws_sns_topic.this.arn
}