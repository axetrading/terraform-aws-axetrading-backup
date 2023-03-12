resource "aws_sns_topic" "this" {
  name_prefix       = format("%s-vault-events-", var.name)
  kms_master_key_id = try(aws_kms_alias.this.id, var.kms_key_id, null)
}

data "aws_iam_policy_document" "this" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Publish",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.this.arn,
    ]

    sid = "__default_statement_ID"
  }
}

resource "aws_sns_topic_policy" "this" {
  arn    = aws_sns_topic.this.arn
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_sns_topic_subscription" "this" {
  for_each  = toset(var.email_recipients)
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = each.key
}

resource "aws_backup_vault_notifications" "this" {
  backup_vault_name   = aws_backup_vault.this.name
  sns_topic_arn       = aws_sns_topic.this.arn
  backup_vault_events = var.backup_vault_events
}