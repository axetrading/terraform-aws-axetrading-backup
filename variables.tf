variable "region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-2"
}

variable "name" {
  type        = string
  description = "The base name used to create the KMS key, SNS topic, IAM role, backup vault, and plan."
}

#### AWS Backup variables

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
variable "create_role" {
  type        = bool
  description = "Wheter to create an IAM role or not"
  default     = true
}

variable "iam_role_name" {
  type        = string
  description = "Name of the IAM role used for AWS Backups"
  default     = "aws-backup-role"
}

variable "provided_iam_role_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) of an existing IAM role that should be used by AWS Backups. The ARN should have the format `arn:aws:iam::account-id:role/role-name`. If not provided, a new IAM role will be created."
  default     = ""
  validation {
    condition     = length(var.provided_iam_role_arn) == 0 || can(regex("^arn:aws:iam::[0-9]{12}:role/.*", var.provided_iam_role_arn))
    error_message = "The provided IAM role ARN is not valid. The ARN should have the format `arn:aws:iam::account-id:role/role-name`."
  }
}

variable "iam_role_policy" {
  type        = string
  description = "Name of the IAM role used for AWS Backups"
  default     = "aws-backup-policy"
}

### KMS variables
variable "kms_key_id" {
  type        = string
  description = "The KMS master key ID to use for encrypting messages sent to the SNS topic. If not specified, the default KMS key for the region will be used."
  default     = null
}


### SNS variables

variable "backup_vault_events" {
  type        = list(string)
  description = "List of events to trigger the backup vault notification"
  default     = ["BACKUP_JOB_STARTED", "RESTORE_JOB_COMPLETED", "BACKUP_JOB_FAILED", "BACKUP_JOB_FAILED"]
}

variable "backup_selection" {
  description = "A map of backup selection configurations, where each key represents a unique backup selection"
  type        = map(any)
}

variable "email_recipients" {
  description = "A list of email addresses that should receive the SNS topic notifications."
  type        = list(string)
  default     = []
  validation {
    condition = alltrue([
      for recipient in var.email_recipients : can(regex("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$", recipient))
    ])
    error_message = "All recipients must be valid email addresses."
  }
}
