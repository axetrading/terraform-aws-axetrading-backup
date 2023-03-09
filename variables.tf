variable "region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-2"
}

#### AWS Backup variables
variable "backup_vault_name" {
  type        = string
  description = "Name for AWS Backup Vault"
  default     = null
}

variable "backup_vault_plan" {
  type        = string
  description = "Name for AWS Backup Vault Plan"
  default     = null
}

variable "backup_rule_name" {
  type        = string
  description = "Name of the Rule used for AWS Backup Vault Plan"
  default     = "daily-backup"
}

variable "backup_schedule" {
  type        = string
  description = "Cronjob for desired backup schedule"
  default     = "cron(30 07 * * ? *)"
}

variable "backup_retention_days" {
  type        = string
  description = "Value for desired number of days to move backups to cold storage"
  default     = 30
}

variable "backup_plan_start_window" {
  type        = string
  description = "Value for desired number of days to move backups to cold storage"
  default     = 60
}

variable "backup_plan_complete_window" {
  type        = string
  description = "Value for desired number of days to move backups to cold storage"
  default     = 120
}

variable "backup_selection_name" {
  type        = string
  description = "Value for AWS Backup selection name, which association is made by tags"
  default     = "backup-selection"
}

variable "backup_selection_conditions" {
  type = map(string)
  default = {
    Backup      = null
    Environment = null
  }
}


#### IAM variables
variable "iam_role_name" {
  type        = string
  description = "Name of the IAM role used for AWS Backups"
  default     = "aws-backup-role"
}

variable "iam_role_policy" {
  type        = string
  description = "Name of the IAM role used for AWS Backups"
  default     = "aws-backup-policy"
}

### KMS variables
variable "kms_key_alias" {
  type        = string
  description = "Name of the IAM role used for AWS Backups"
  default     = "alias/aws-backup-key"
}

### SNS variables
variable "sns_topic_name" {
  type        = string
  description = "Name of the SNS topic name used for AWS Backups"
  default     = "backup-vault-events"
}

variable "backup_vault_events" {
  type        = list(string)
  description = "List of events to trigger the backup vault notification"
  default     = ["BACKUP_JOB_STARTED", "RESTORE_JOB_COMPLETED"]
}

variable "backup_selection" {
  description = "A map of backup selection configurations, where each key represents a unique backup selection"
  type        = map(any)
}
