# IAM role for AWS backups
resource "aws_iam_role" "aws_backup_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "backup.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM policy for AWS backups
resource "aws_iam_policy" "aws_backup_policy" {
  name = var.iam_role_policy
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "rds:DescribeDBClusters",
          "rds:DescribeDBInstances",
          "rds:ListTagsForResource",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:CreateTags",
          "ec2:CreateSnapshot",
          "ec2:DeleteTags",
          "backup:CreateBackupPlan",
          "backup:DeleteBackupPlan",
          "backup:DescribeBackupPlan",
          "backup:DescribeBackupSelection",
          "backup:CreateBackupSelection",
          "backup:DeleteBackupSelection",
          "backup:StartBackupJob",
          "backup:GetBackupVaultAccessPolicy",
          "backup:PutBackupVaultAccessPolicy",
          "backup:GetBackupVaultNotifications",
          "backup:PutBackupVaultNotifications"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "aws_backup_role_policy_attachment" {
  policy_arn = aws_iam_policy.aws_backup_policy.arn
  role       = aws_iam_role.aws_backup_role.name
}

/* resource "aws_iam_role_policy_attachment" "aws_backup_role_policy_backup" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role = aws_iam_role.aws_backup_role.name
} */

resource "aws_iam_role_policy_attachment" "aws_backup_role_policy_restores" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  role       = aws_iam_role.aws_backup_role.name
}