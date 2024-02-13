/**
 * # AWS Backup Terraform Module
 *
 * This module produce aws backup for resources like RDS,EBS based on tags that they have.
 *
 */
locals {
  role_arn = var.create_role ? aws_iam_role.aws_backup_role[0].arn : var.provided_iam_role_arn
}

resource "aws_backup_vault" "this" {
  name        = format("%s-%s", var.name, "vault")
  kms_key_arn = aws_kms_key.aws_backup_kms_key.arn
  tags        = var.tags
}

resource "aws_backup_vault_lock_configuration" "this" {
  count               = var.backup_vault_lock_config != null ? 1 : 0
  backup_vault_name   = aws_backup_vault.this.name
  changeable_for_days = var.backup_vault_lock_config.changeable_for_days
  max_retention_days  = var.backup_vault_lock_config.max_retention_days
  min_retention_days  = var.backup_vault_lock_config.min_retention_days
}


# Data source for the AWS Backup vault policy document
data "aws_iam_policy_document" "backup_vault_policy" {
  statement {
    sid    = "default"
    effect = "Allow"
    actions = [
      "backup:DescribeBackupVault",
      "backup:DeleteBackupVault",
      "backup:PutBackupVaultAccessPolicy",
      "backup:DeleteBackupVaultAccessPolicy",
      "backup:GetBackupVaultAccessPolicy",
      "backup:StartBackupJob",
      "backup:GetBackupVaultNotifications",
      "backup:PutBackupVaultNotifications"
    ]
    resources = [aws_backup_vault.this.arn]

    principals {
      type        = "AWS"
      identifiers = [local.role_arn]
    }
  }
}

resource "aws_backup_vault_policy" "this" {
  backup_vault_name = aws_backup_vault.this.name
  policy            = data.aws_iam_policy_document.backup_vault_policy.json
}

resource "aws_backup_plan" "this" {
  name = format("%s-%s", var.name, "plan")

  rule {
    rule_name         = var.backup_rule_name
    target_vault_name = aws_backup_vault.this.name
    schedule          = var.backup_schedule
    start_window      = var.backup_plan_start_window
    completion_window = var.backup_plan_complete_window
    lifecycle {
      delete_after = var.backup_retention_days
    }
  }

}

resource "aws_backup_selection" "this" {
  for_each     = var.backup_selection
  name         = each.key
  iam_role_arn = local.role_arn
  plan_id      = aws_backup_plan.this.id
  resources    = ["*"]

  condition {
    dynamic "string_equals" {
      for_each = {
        for key, value in each.value :
        "condition_${key}" => {
          key   = key
          value = value
        }
      }
      content {
        key   = "aws:ResourceTag/${string_equals.value.key}"
        value = string_equals.value.value
      }
    }
  }
}

