output "kms_key_id" {
  value = module.aws_backup_test.kms_key_id
}

output "kms_key_alias_name" {
  value = module.aws_backup_test.kms_key_alias_name
}

output "iam_role_arn" {
  value = module.aws_backup_test.iam_role_arn
}

output "iam_role_name" {
  value = module.aws_backup_test.iam_role_name
}
output "backup_vault_name" {
  value = module.aws_backup_test.backup_vault_name
}

output "backup_vault_arn" {
  value = module.aws_backup_test.backup_vault_arn
}

output "backup_plan_name" {
  value = module.aws_backup_test.backup_plan_name
}

output "backup_plan_id" {
  value = module.aws_backup_test.backup_plan_id
}

output "backup_sns_topic_name" {
  value = module.aws_backup_test.backup_sns_topic_name
}