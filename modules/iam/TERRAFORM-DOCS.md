<!-- BEGIN_TF_DOCS -->
# 

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_account_password_policy.strict](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy) | resource |
| [aws_iam_group.dbadmin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group.monitor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group.sysadmin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_policy_attachment.dbadmin_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_group_policy_attachment.monitor_ec2_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_group_policy_attachment.monitor_rds_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_group_policy_attachment.monitor_s3_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_group_policy_attachment.sysadmin_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_instance_profile.ec2s3_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2s3_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ec2s3_role_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.dbadmin_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.monitor_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.sysadmin_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_group_membership.dbadmin_memberships](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership) | resource |
| [aws_iam_user_group_membership.monitor_memberships](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership) | resource |
| [aws_iam_user_group_membership.sysadmin_memberships](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Tags to apply to all IAM users | `map(string)` | `{}` | no |
| <a name="input_ec2_role"></a> [ec2\_role](#input\_ec2\_role) | EC2 IAM role configuration | <pre>object({<br/>    name = string<br/>  })</pre> | <pre>{<br/>  "name": "EC2toS3IAMRole"<br/>}</pre> | no |
| <a name="input_groups"></a> [groups](#input\_groups) | IAM groups configuration with names | <pre>object({<br/>    sysadmin = object({ name = string })<br/>    dbadmin  = object({ name = string })<br/>    monitor  = object({ name = string })<br/>  })</pre> | <pre>{<br/>  "dbadmin": {<br/>    "name": "DBAdmin"<br/>  },<br/>  "monitor": {<br/>    "name": "Monitor"<br/>  },<br/>  "sysadmin": {<br/>    "name": "SysAdmin"<br/>  }<br/>}</pre> | no |
| <a name="input_max_password_age"></a> [max\_password\_age](#input\_max\_password\_age) | Maximum password age in days before reset | `number` | `90` | no |
| <a name="input_minimum_password_length"></a> [minimum\_password\_length](#input\_minimum\_password\_length) | Minimum length for IAM passwords | `number` | `8` | no |
| <a name="input_password_reuse_prevention"></a> [password\_reuse\_prevention](#input\_password\_reuse\_prevention) | Number of previous passwords that cannot be reused | `number` | `3` | no |
| <a name="input_require_lowercase_characters"></a> [require\_lowercase\_characters](#input\_require\_lowercase\_characters) | Require lowercase letters in IAM passwords | `bool` | `true` | no |
| <a name="input_require_numbers"></a> [require\_numbers](#input\_require\_numbers) | Require numbers in IAM passwords | `bool` | `true` | no |
| <a name="input_require_symbols"></a> [require\_symbols](#input\_require\_symbols) | Require special characters in IAM passwords | `bool` | `true` | no |
| <a name="input_require_uppercase_characters"></a> [require\_uppercase\_characters](#input\_require\_uppercase\_characters) | Require uppercase letters in IAM passwords | `bool` | `true` | no |
| <a name="input_users"></a> [users](#input\_users) | Maps of IAM usernames by group | <pre>object({<br/>    sysadmin = map(string)<br/>    dbadmin  = map(string)<br/>    monitor  = map(string)<br/>  })</pre> | <pre>{<br/>  "dbadmin": {<br/>    "dbadmin1": "dbadmin1",<br/>    "dbadmin2": "dbadmin2"<br/>  },<br/>  "monitor": {<br/>    "monitor1": "monitor1",<br/>    "monitor2": "monitor2",<br/>    "monitor3": "monitor3",<br/>    "monitor4": "monitor4"<br/>  },<br/>  "sysadmin": {<br/>    "sysadmin1": "sysadmin1",<br/>    "sysadmin2": "sysadmin2"<br/>  }<br/>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dbadmin_users"></a> [dbadmin\_users](#output\_dbadmin\_users) | List of DBAdmin IAM usernames |
| <a name="output_ec2_instance_profile"></a> [ec2\_instance\_profile](#output\_ec2\_instance\_profile) | EC2 instance profile name |
| <a name="output_ec2_role_arn"></a> [ec2\_role\_arn](#output\_ec2\_role\_arn) | ARN of EC2 IAM Role with S3 full access |
| <a name="output_monitor_users"></a> [monitor\_users](#output\_monitor\_users) | List of Monitor IAM usernames |
| <a name="output_sysadmin_users"></a> [sysadmin\_users](#output\_sysadmin\_users) | List of SysAdmin IAM usernames |
<!-- END_TF_DOCS -->