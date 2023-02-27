output "iam_role_arn" {
  value = aws_iam_role.aws_backup_role.arn
}

output "kms_key_id" {
  value = aws_kms_key.aws_backup_kms_key.key_id
}

output "backup_vault_arn" {
  value = aws_backup_vault.this.arn
}

output "backup_plan_id" {
  value = aws_backup_plan.this.id
}

output "backup_selection_plan_id" {
  value = aws_backup_selection.this.id
}