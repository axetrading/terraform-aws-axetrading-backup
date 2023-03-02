# terraform-aws-axetrading-backup
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.50 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.56.0 |

## Resources

| Name | Type |
|------|------|
| [aws_backup_plan.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_selection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault_notifications.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_notifications) | resource |
| [aws_backup_vault_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy) | resource |
| [aws_iam_role.aws_backup_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aws_backup_role_policy_backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.aws_backup_role_policy_restores](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.aws_backup_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.backup_vault_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.iam_role_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_plan_complete_window"></a> [backup\_plan\_complete\_window](#input\_backup\_plan\_complete\_window) | Value for desired number of days to move backups to cold storage | `string` | `120` | no |
| <a name="input_backup_plan_start_window"></a> [backup\_plan\_start\_window](#input\_backup\_plan\_start\_window) | Value for desired number of days to move backups to cold storage | `string` | `60` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | Value for desired number of days to move backups to cold storage | `string` | `30` | no |
| <a name="input_backup_rule_name"></a> [backup\_rule\_name](#input\_backup\_rule\_name) | Name of the Rule used for AWS Backup Vault Plan | `string` | `"daily-backup"` | no |
| <a name="input_backup_schedule"></a> [backup\_schedule](#input\_backup\_schedule) | Cronjob for desired backup schedule | `string` | `"cron(21 15 * * ? *)"` | no |
| <a name="input_backup_selection_conditions"></a> [backup\_selection\_conditions](#input\_backup\_selection\_conditions) | n/a | `map(string)` | <pre>{<br>  "Backup": "true",<br>  "Environmet": "dev"<br>}</pre> | no |
| <a name="input_backup_selection_name"></a> [backup\_selection\_name](#input\_backup\_selection\_name) | Value for AWS Backup selection name, which association is made by tags | `string` | `"backup-selection"` | no |
| <a name="input_backup_vault_events"></a> [backup\_vault\_events](#input\_backup\_vault\_events) | List of events to trigger the backup vault notification | `list(string)` | <pre>[<br>  "BACKUP_JOB_STARTED",<br>  "RESTORE_JOB_COMPLETED"<br>]</pre> | no |
| <a name="input_backup_vault_name"></a> [backup\_vault\_name](#input\_backup\_vault\_name) | Name for AWS Backup Vault | `string` | `null` | no |
| <a name="input_backup_vault_plan"></a> [backup\_vault\_plan](#input\_backup\_vault\_plan) | Name for AWS Backup Vault Plan | `string` | `null` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | Name of the IAM role used for AWS Backups | `string` | `"aws-backup-role"` | no |
| <a name="input_iam_role_policy"></a> [iam\_role\_policy](#input\_iam\_role\_policy) | Name of the IAM role used for AWS Backups | `string` | `"aws-backup-policy"` | no |
| <a name="input_kms_key_alias"></a> [kms\_key\_alias](#input\_kms\_key\_alias) | Name of the IAM role used for AWS Backups | `string` | `"alias/aws-backup-key"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"eu-west-2"` | no |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | Name of the SNS topic name used for AWS Backups | `string` | `"backup-vault-events"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_plan_id"></a> [backup\_plan\_id](#output\_backup\_plan\_id) | n/a |
| <a name="output_backup_selection_plan_id"></a> [backup\_selection\_plan\_id](#output\_backup\_selection\_plan\_id) | n/a |
| <a name="output_backup_sns_topic_arn"></a> [backup\_sns\_topic\_arn](#output\_backup\_sns\_topic\_arn) | SNS |
| <a name="output_backup_vault_arn"></a> [backup\_vault\_arn](#output\_backup\_vault\_arn) | AWS Backup |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | IAM |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS |
<!-- END_TF_DOCS -->