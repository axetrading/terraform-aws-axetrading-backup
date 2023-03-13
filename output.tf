# IAM 
output "iam_role_arn" {
  description = "ARN of the IAM role"
  value       = try(aws_iam_role.aws_backup_role[0].arn, "")
}

output "iam_role_name" {
  value       = try(aws_iam_role.aws_backup_role[0].name, "")
  description = "The name of the IAM role that was created for AWS Backup."
}


# KMS
output "kms_key_id" {
  description = "ID of the KMS key"
  value       = aws_kms_key.aws_backup_kms_key.key_id
}

output "kms_key_alias_name" {
  value       = aws_kms_alias.this.name
  description = "The name of the KMS key alias that was created for AWS Backup."
}


# AWS Backup
output "backup_vault_arn" {
  description = "ARN of the Backup Vault"
  value       = aws_backup_vault.this.arn
}

output "backup_vault_name" {
  value       = aws_backup_vault.this.name
  description = "The name of the AWS Backup vault that was created."
}

output "backup_plan_name" {
  value       = aws_backup_plan.this.name
  description = "The name of the AWS Backup plan that was created."
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

output "backup_sns_topic_name" {
  description = "ARN of the SNS topic used for AWS backup notifications"
  value       = aws_sns_topic.this.name
}