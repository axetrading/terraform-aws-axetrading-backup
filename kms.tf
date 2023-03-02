# KMS key for encrypting AWS backups
resource "aws_kms_key" "aws_backup_kms_key" {
  description = "KMS key for encrypting AWS backups"

  # Policy to allow the IAM role to access this key
  policy = data.aws_iam_policy_document.kms_key_policy.json

}

# Set an alias for the key
resource "aws_kms_alias" "this" {
  name          = var.kms_key_alias
  target_key_id = aws_kms_key.aws_backup_kms_key.key_id
}

# Data source for the KMS key policy document
data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid       = "Allow access to key"
    actions   = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:PutKeyPolicy",
      "kms:RetireGrant"
    ]
    resources = ["*"]
    effect    = "Allow"

    principals {
      type        = "AWS"
      identifiers = [ "arn:aws:iam::${local.account_id}:role/${aws_iam_role.aws_backup_role.name}" ]
    }
  }

  statement {
    sid       = "Restrict IAM user permissions to current AWS account ID"
    actions   = [ "kms:*" ]
    resources = ["*"]
    effect    = "Allow"

    principals {
      type        = "AWS"
      identifiers = [ "arn:aws:iam::${local.account_id}:root" ]
    }
  }
}