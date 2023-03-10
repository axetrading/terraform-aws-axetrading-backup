# terraform-aws-axetrading-backup
<!-- BEGIN_TF_DOCS -->
# AWS Backup Terraform Module

This module produce aws backup for resources like RDS,EBS based on tags that they have.

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
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
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
| <a name="input_backup_schedule"></a> [backup\_schedule](#input\_backup\_schedule) | Cronjob for desired backup schedule | `string` | `"cron(30 07 * * ? *)"` | no |
| <a name="input_backup_selection"></a> [backup\_selection](#input\_backup\_selection) | A map of backup selection configurations, where each key represents a unique backup selection | `map(any)` | n/a | yes |
| <a name="input_backup_selection_conditions"></a> [backup\_selection\_conditions](#input\_backup\_selection\_conditions) | n/a | `map(string)` | <pre>{<br>  "Backup": null,<br>  "Environment": null<br>}</pre> | no |
| <a name="input_backup_selection_name"></a> [backup\_selection\_name](#input\_backup\_selection\_name) | Value for AWS Backup selection name, which association is made by tags | `string` | `"backup-selection"` | no |
| <a name="input_backup_vault_events"></a> [backup\_vault\_events](#input\_backup\_vault\_events) | List of events to trigger the backup vault notification | `list(string)` | <pre>[<br>  "BACKUP_JOB_STARTED",<br>  "RESTORE_JOB_COMPLETED",<br>  "BACKUP_JOB_FAILED",<br>  "BACKUP_JOB_FAILED"<br>]</pre> | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Wheter to create an IAM role or not | `bool` | `true` | no |
| <a name="input_email_recipients"></a> [email\_recipients](#input\_email\_recipients) | A list of email addresses that should receive the SNS topic notifications. | `list(string)` | `[]` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | Name of the IAM role used for AWS Backups | `string` | `"aws-backup-role"` | no |
| <a name="input_iam_role_policy"></a> [iam\_role\_policy](#input\_iam\_role\_policy) | Name of the IAM role used for AWS Backups | `string` | `"aws-backup-policy"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The KMS master key ID to use for encrypting messages sent to the SNS topic. If not specified, the default KMS key for the region will be used. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The base name used to create the KMS key, SNS topic, IAM role, backup vault, and plan. | `string` | n/a | yes |
| <a name="input_provided_iam_role_arn"></a> [provided\_iam\_role\_arn](#input\_provided\_iam\_role\_arn) | The Amazon Resource Name (ARN) of an existing IAM role that should be used by AWS Backups. The ARN should have the format `arn:aws:iam::account-id:role/role-name`. If not provided, a new IAM role will be created. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"eu-west-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_plan_id"></a> [backup\_plan\_id](#output\_backup\_plan\_id) | ID of the backup plan |
| <a name="output_backup_plan_name"></a> [backup\_plan\_name](#output\_backup\_plan\_name) | The name of the AWS Backup plan that was created. |
| <a name="output_backup_selection_plan_id"></a> [backup\_selection\_plan\_id](#output\_backup\_selection\_plan\_id) | ID of the backup selection plan |
| <a name="output_backup_sns_topic_arn"></a> [backup\_sns\_topic\_arn](#output\_backup\_sns\_topic\_arn) | ARN of the SNS topic used for AWS backup notifications |
| <a name="output_backup_sns_topic_name"></a> [backup\_sns\_topic\_name](#output\_backup\_sns\_topic\_name) | ARN of the SNS topic used for AWS backup notifications |
| <a name="output_backup_vault_arn"></a> [backup\_vault\_arn](#output\_backup\_vault\_arn) | ARN of the Backup Vault |
| <a name="output_backup_vault_name"></a> [backup\_vault\_name](#output\_backup\_vault\_name) | The name of the AWS Backup vault that was created. |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of the IAM role |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | The name of the IAM role that was created for AWS Backup. |
| <a name="output_kms_key_alias_name"></a> [kms\_key\_alias\_name](#output\_kms\_key\_alias\_name) | The name of the KMS key alias that was created for AWS Backup. |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | ID of the KMS key |
<!-- END_TF_DOCS -->