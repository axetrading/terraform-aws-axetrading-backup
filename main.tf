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

resource "aws_backup_framework" "this" {
  count       = var.framework_controls != null ? 1 : 0
  name        = replace(format("%s-%s", var.name, "backup-framework"), "-", "_")
  description = "Framework for ${format("%s", var.name)} AWS Backup to evaluate compliance of resources against a set of rules"

  dynamic "control" {
    for_each = var.framework_controls

    content {
      name = control.value.name

      dynamic "input_parameter" {
        for_each = control.value.input_parameters

        content {
          name  = input_parameter.value.name
          value = input_parameter.value.value
        }
      }

      dynamic "scope" {
        for_each = control.value.scope

        content {
          compliance_resource_types = scope.value.compliance_resource_types
          compliance_resource_ids   = scope.value.compliance_resource_ids
          tags                      = scope.value.tags
        }
      }
    }
  }

  tags = var.tags

  timeouts {
    create = "10m"
    delete = "10m"
    update = "10m"
  }
}

resource "aws_backup_report_plan" "this" {
  for_each = { for report in var.reports : report.name => report }

  name        = each.value.name
  description = each.value.description

  report_delivery_channel {
    formats        = each.value.formats
    s3_bucket_name = each.value.s3_bucket_name
    s3_key_prefix  = each.value.s3_key_prefix
  }

  report_setting {
    report_template      = each.value.report_template
    accounts             = each.value.accounts
    organization_units   = each.value.organization_units
    regions              = each.value.regions
    framework_arns       = var.framework_controls != null ? concat([aws_backup_framework.this[0].arn], each.value.framework_arns) : each.value.framework_arns
    number_of_frameworks = length(each.value.framework_arns)
  }

  tags = var.tags
}