# Data source for the IAM role assume role policy document
data "aws_iam_policy_document" "iam_role_assume_policy" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# IAM role for AWS backups
resource "aws_iam_role" "aws_backup_role" {
  count              = var.create_role ? 1 : 0
  name_prefix        = format("%s-", var.name)
  assume_role_policy = data.aws_iam_policy_document.iam_role_assume_policy.json
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "aws_backup_role_policy_backup" {
  count      = var.create_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.aws_backup_role[0].name
}

resource "aws_iam_role_policy_attachment" "aws_backup_role_policy_restores" {
  count      = var.create_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  role       = aws_iam_role.aws_backup_role[0].name
}

resource "aws_iam_role_policy_attachment" "aws_backup_role_policy_s3_backup" {
  count      = var.create_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Backup"
  role       = aws_iam_role.aws_backup_role[0].name
}


resource "aws_iam_role_policy_attachment" "aws_backup_role_policy_s3_restore" {
  count      = var.create_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Restore"
  role       = aws_iam_role.aws_backup_role[0].name
}