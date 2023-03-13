module "aws_backup_test" {
  source           = "../../"
  name             = var.name
  email_recipients = var.email_recipients
  backup_schedule  = var.backup_schedule
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