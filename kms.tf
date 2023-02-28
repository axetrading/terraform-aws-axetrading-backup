# KMS key for encrypting AWS backups
resource "aws_kms_key" "aws_backup_kms_key" {
  description = "KMS key for encrypting AWS backups"

  # Policy to allow the IAM role to access this key
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "Allow access to key",
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:PutKeyPolicy",
          "kms:RetireGrant"
        ],
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:role/${aws_iam_role.aws_backup_role.name}"
        },
        Resource = "*"
      },
      {
        Sid    = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action   = "kms:*",
        Resource = "*"
      }
    ]
  })
}

# Set an alias for the key
resource "aws_kms_alias" "this" {
  name          = var.kms_key_alias
  target_key_id = aws_kms_key.aws_backup_kms_key.key_id
}