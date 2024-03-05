variable "name" {
  type        = string
  description = "The base name used to create the KMS key, SNS topic, IAM role, backup vault, and plan."
}

variable "backup_schedule" {
  type        = string
  description = "Cronjob for desired backup schedule"
  default     = "cron(30 07 * * ? *)"
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