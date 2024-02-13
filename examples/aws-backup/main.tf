module "aws_backup_test" {
  source           = "../../"
  name             = var.name
  email_recipients = var.email_recipients
  backup_schedule  = var.backup_schedule
  backup_vault_lock_config = {
    #changeable_for_days = 3
    max_retention_days  = 60
    min_retention_days  = 1
  }
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