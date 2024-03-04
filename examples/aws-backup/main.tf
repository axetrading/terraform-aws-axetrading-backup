module "aws_backup_test" {
  source           = "../../"
  name             = var.name
  email_recipients = var.email_recipients
  backup_schedule  = var.backup_schedule
  backup_vault_lock_config = {
    #changeable_for_days = 3
    max_retention_days = 60
    min_retention_days = 1
  }
  framework_controls = [
    {
      name = "BACKUP_RECOVERY_POINT_MINIMUM_RETENTION_CHECK",
      input_parameters = [
        {
          name  = "requiredRetentionDays"
          value = "60"
        }
      ],
      scope = []
    },
    {
      name             = "BACKUP_RESOURCES_PROTECTED_BY_BACKUP_PLAN",
      input_parameters = [],
      scope            = []
    },
    {
      name = "BACKUP_PLAN_MIN_FREQUENCY_AND_MIN_RETENTION_CHECK",
      input_parameters = [
        {
          name  = "requiredFrequencyUnit"
          value = "hours"
        },
        {
          name  = "requiredRetentionDays"
          value = "60"
        },
        {
          name  = "requiredFrequencyValue"
          value = "24"
        }
      ],
      scope = []
    },
    {
      name             = "BACKUP_RECOVERY_POINT_ENCRYPTED",
      input_parameters = [],
      scope            = []
    },
    {
      name = "BACKUP_RESOURCES_PROTECTED_BY_BACKUP_VAULT_LOCK",
      input_parameters = [
        {
          name  = "maxRetentionDays"
          value = "60"
        },
        {
          name  = "minRetentionDays"
          value = "1"
        }
      ],
      scope = [
        {
          compliance_resource_types = ["EBS", "RDS", "EFS", "EC2", "Aurora"]
        }
      ]
    },
    {
      name             = "BACKUP_RECOVERY_POINT_MANUAL_DELETION_DISABLED",
      input_parameters = [],
      scope            = []
    },
    {
      name = "BACKUP_LAST_RECOVERY_POINT_CREATED",
      input_parameters = [
        {
          name  = "recoveryPointAgeUnit"
          value = "days"
        },
        {
          name  = "recoveryPointAgeValue"
          value = "1"
        }
      ],
      scope = [
        {
          compliance_resource_types = ["EBS", "RDS", "EFS", "EC2", "Aurora"]
        }
      ]
    }
    // Add other controls as needed...
  ]
  backup_selection = {
    dev = {
      "Environment" = "dev"
      "Backup"      = "true"

    },
    uat = {
      "Environment" = "uat"
      "Backup"      = "true"
    }
  }
}