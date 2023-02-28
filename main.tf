resource "aws_backup_vault" "this" {
  name        = var.backup_vault_name
  kms_key_arn = aws_kms_key.aws_backup_kms_key.arn
}

resource "aws_backup_vault_policy" "this" {
  backup_vault_name = aws_backup_vault.this.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "default",
  "Statement": [
    {
      "Sid": "default",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.aws_backup_role.arn}"
      },
      "Action": [
        "backup:DescribeBackupVault",
        "backup:DeleteBackupVault",
        "backup:PutBackupVaultAccessPolicy",
        "backup:DeleteBackupVaultAccessPolicy",
        "backup:GetBackupVaultAccessPolicy",
        "backup:StartBackupJob",
        "backup:GetBackupVaultNotifications",
        "backup:PutBackupVaultNotifications"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_backup_plan" "this" {
  name = var.backup_vault_plan

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
  name         = var.backup_selection_name
  iam_role_arn = aws_iam_role.aws_backup_role.arn
  plan_id      = aws_backup_plan.this.id
  resources    = ["*"]

  condition {
    string_equals {
      key   = var.backup_selection_condition_key
      value = var.backup_selection_condition_value
    }
  }

  depends_on = [
    aws_backup_plan.this
  ]

}